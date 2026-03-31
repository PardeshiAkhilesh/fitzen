import 'package:flutter/material.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/hero_image_card.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/api_constants.dart';


class WorkoutDay {
  final int id;
  final int dayNumber;
  final String dayLabel;
  String title;
  List<Map<String, String>> exercises;

  WorkoutDay({required this.id, required this.dayNumber, required this.dayLabel, required this.title, required this.exercises});
}

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<WorkoutDay> _plan = [];
  final Set<int> _completed = <int>{};
  bool _loading = true;
  final Map<int, int> _burnResults = {};
  final Map<int, GlobalKey> _dayKeys = {};

  @override
  void initState() {
    super.initState();
    // Install a temporary ErrorWidget to show helpful errors in the UI
    ErrorWidget.builder = (FlutterErrorDetails details) {
      debugPrint('GoalsScreen build error: ${details.exception}');
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('An error occurred rendering My Goals:\n${details.exceptionAsString()}', textAlign: TextAlign.center, style: AppTextStyles.caption),
        ),
      );
    };

    _loadPlan();
  }

  Future<void> _loadPlan() async {
    if (mounted) setState(() => _loading = true);
    try {
      final res = await ApiService.get(ApiConstants.workoutPlan);
      debugPrint('workout plan response: ${res.runtimeType} -> $res');
      final days = <WorkoutDay>[];
      final items = (res as List?) ?? [];
      for (var item in items) {
        final exs = <Map<String, String>>[];
        final list = item['exercises'] as List? ?? [];
        for (var e in list) {
          exs.add({
            'name': e['name']?.toString() ?? '',
            'sets': e['sets']?.toString() ?? '',
            'reps': e['reps']?.toString() ?? '',
          });
        }
        days.add(WorkoutDay(id: item['id'] ?? 0, dayNumber: item['day_number'] ?? 0, dayLabel: item['day_label'] ?? 'Day', title: item['title'] ?? 'Workout', exercises: exs));
      }

      // If backend returned unexpected shape or empty, show a small fallback plan so UI is visible
      if (days.isEmpty) {
        debugPrint('Using fallback plan (API returned empty or invalid)');
        days.addAll([
          WorkoutDay(id: 1, dayNumber: 1, dayLabel: 'Mon', title: 'Full Body', exercises: [
            {'name': 'Squats', 'sets': '3', 'reps': '12'},
            {'name': 'Push Ups', 'sets': '3', 'reps': '10'},
          ]),
          WorkoutDay(id: 2, dayNumber: 2, dayLabel: 'Tue', title: 'Cardio', exercises: [
            {'name': 'Running', 'sets': '1', 'reps': '30min'},
          ]),
        ]);
      }

      if (mounted) {
        setState(() {
          _plan = days;
          _dayKeys.clear();
          for (var d in _plan) {
            _dayKeys[d.id] = GlobalKey();
          }
        });
        debugPrint('Plan set: ${_plan.length} items');
      }
    } catch (e) {
      debugPrint('Failed loading plan: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveDay(WorkoutDay day) async {
    final payload = {
      'title': day.title,
      'exercises': day.exercises.map((e) => {'name': e['name'], 'sets': e['sets'], 'reps': e['reps']}).toList()
    };
    try {
      await ApiService.put('${ApiConstants.workoutPlan}/${day.id}', payload);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
      await _loadPlan();
    } catch (e) {
      debugPrint('Save day error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
    }
  }

  Future<void> _completeDay(WorkoutDay day) async {
    // Build completed exercises payload: sets as int if possible
    final exercises = day.exercises.map((e) {
      final sets = int.tryParse(e['sets'] ?? '') ?? 1;
      return {'name': e['name'], 'sets': sets, 'reps': e['reps'] ?? ''};
    }).toList();

    final payload = {'day_title': day.title, 'exercises': exercises};
    try {
      final res = await ApiService.post(ApiConstants.workoutPlanCalculateBurn, payload);
      debugPrint('Calculate burn: $res');
      // store burn results per day id if provided
      final cal = (res['total_calories'] as num?)?.toInt() ?? 0;
      setState(() => _burnResults[day.id] = cal);
      if (!mounted) return;
      setState(() => _completed.add(day.id));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout recorded')));
    } catch (e) {
      debugPrint('Complete day error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to record: $e')));
    }
  }

  void _showEditDay(WorkoutDay day) {
    final titleCtrl = TextEditingController(text: day.title);
    final exCtrls = day.exercises.map((e) => {
      'name': TextEditingController(text: e['name']),
      'sets': TextEditingController(text: e['sets']),
      'reps': TextEditingController(text: e['reps']),
    }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            child: StatefulBuilder(builder: (ctx, sb) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('Edit Day', style: AppTextStyles.h2),
                  const SizedBox(height: 12),
                  TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
                  const SizedBox(height: 12),
                  ...List.generate(exCtrls.length, (i) {
                    final c = exCtrls[i];
                    return Row(children: [
                      Expanded(child: TextField(controller: c['name'], decoration: const InputDecoration(labelText: 'Exercise'))),
                      const SizedBox(width: 8),
                      SizedBox(width: 64, child: TextField(controller: c['sets'], decoration: const InputDecoration(labelText: 'Sets'))),
                      const SizedBox(width: 8),
                      SizedBox(width: 80, child: TextField(controller: c['reps'], decoration: const InputDecoration(labelText: 'Reps'))),
                      IconButton(onPressed: () { sb(() { exCtrls.removeAt(i); }); }, icon: const Icon(Icons.delete))
                    ]);
                  }),
                  const SizedBox(height: 8),
                  Row(children: [
                    ElevatedButton(onPressed: () { sb(() { exCtrls.add({'name': TextEditingController(), 'sets': TextEditingController(text: '3'), 'reps': TextEditingController(text: '10')}); }); }, child: const Text('Add Exercise')),
                    const Spacer(),
                    ElevatedButton(onPressed: () {
                      // save
                      final updated = <Map<String,String>>[];
                      for (var c in exCtrls) {
                        updated.add({
                          'name': c['name']?.text ?? '',
                          'sets': c['sets']?.text ?? '',
                          'reps': c['reps']?.text ?? ''
                        });
                      }
                      day.title = titleCtrl.text;
                      day.exercises = updated;
                      Navigator.of(ctx).pop();
                      _saveDay(day);
                    }, child: const Text('Save'))
                  ])
                ]),
              );
            }),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      // keep building below
    } catch (e, st) {
      debugPrint('Build error in GoalsScreen: $e\n$st');
      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(title: const Text('My Goals'), backgroundColor: Colors.white, centerTitle: true),
        body: Center(child: Padding(padding: const EdgeInsets.all(16), child: Text('Build error: $e', style: AppTextStyles.caption))),
      );
    }
    // week date calculations not needed for redesigned UI

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('My Goals'),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.maybeOf(context);
              try {
                await ApiService.post('${ApiConstants.workoutPlan}/reset', {});
                await _loadPlan();
                if (!mounted) return;
                messenger?.showSnackBar(const SnackBar(content: Text('Plan reset')));
              } catch (e) {
                if (!mounted) return;
                messenger?.showSnackBar(SnackBar(content: Text('Reset failed: $e')));
              }
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _plan.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('No workout plan found. Tap ↺ to reset to default.', style: AppTextStyles.caption, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.maybeOf(context);
                          try {
                            await ApiService.post('${ApiConstants.workoutPlan}/reset', {});
                            await _loadPlan();
                            if (!mounted) return;
                          } catch (e) {
                            if (!mounted) return;
                            messenger?.showSnackBar(SnackBar(content: Text('Reset failed: $e')));
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                        child: const Text('Reset Plan'),
                      )
                    ]),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    HeroImageCard(
                      imageUrl: AppImages.trainerHero,
                      height: 220,
                      overlay: AppColors.imageOverlayDark,
                      content: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [Text('Your Coach', style: AppTextStyles.captionWhite70), Text('Elite Fit AI', style: AppTextStyles.labelWhite)]),
                    ),
                    const SizedBox(height: 20),
                    // Weekly progress strip (fixed height horizontal ListView)
                    SizedBox(
                      height: 96,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _plan.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                          itemBuilder: (ctx, i) {
                          final d = _plan[i];
                          final completed = _completed.contains(d.id);
                          return GestureDetector(
                            onTap: () {
                              final key = _dayKeys[d.id];
                              if (key != null && key.currentContext != null) {
                                Scrollable.ensureVisible(key.currentContext!, duration: const Duration(milliseconds: 300), alignment: 0.1);
                              }
                            },
                            child: Container(
                              width: 110,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: AppColors.cardShadow),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(children: [
                                  Container(width: 12, height: 12, decoration: BoxDecoration(color: completed ? Colors.green : AppColors.divider, shape: BoxShape.circle)),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(d.dayLabel, style: AppTextStyles.caption)),
                                ]),
                                const SizedBox(height: 8),
                                Text(d.title, style: AppTextStyles.h3, maxLines: 2, overflow: TextOverflow.ellipsis),
                              ]),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Plan list
                    ..._plan.map((d) {
                      return Padding(
                        key: _dayKeys[d.id],
                        padding: const EdgeInsets.only(bottom: 14, top: 6),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: AppColors.cardShadow),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Text(d.dayLabel, style: AppTextStyles.caption),
                              const SizedBox(width: 12),
                              Expanded(child: Text(d.title, style: AppTextStyles.h3, overflow: TextOverflow.ellipsis)),
                              Flexible(child: SizedBox(width: 44, child: IconButton(onPressed: () => _showEditDay(d), icon: const Icon(Icons.edit, size: 20)))),
                            ]),
                            const SizedBox(height: 8),
                            Column(children: d.exercises.map((e) {
                              return Column(children: [
                                Row(children: [
                                  Expanded(child: Text(e['name'] ?? '', style: AppTextStyles.body, overflow: TextOverflow.ellipsis)),
                                  const SizedBox(width: 8),
                                  Text('${e['sets'] ?? ''} x ${e['reps'] ?? ''}', style: AppTextStyles.caption),
                                ]),
                                const SizedBox(height: 8),
                                const Divider(height: 1, color: AppColors.divider),
                                const SizedBox(height: 8),
                              ]);
                            }).toList()),
                            const SizedBox(height: 8),
                            Row(children: [
                              if (_completed.contains(d.id))
                                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)), child: Text('✓ Done', style: AppTextStyles.caption.copyWith(color: Colors.white)))
                              else
                                Flexible(child: ElevatedButton(onPressed: () => _completeDay(d), style: ElevatedButton.styleFrom(backgroundColor: AppColors.red), child: const Text('Complete Day'))),
                              const SizedBox(width: 12),
                            ]),
                            if (_burnResults.containsKey(d.id)) ...[
                              const SizedBox(height: 8),
                              Text('~${_burnResults[d.id]} kcal burned', style: AppTextStyles.caption),
                            ]
                          ]),
                        ),
                      );
                    }),
                  ],
                ),
    );
  }

  // ignore: unused_element
  List<Widget> _buildPlanWidgets() {
    try {
      return _plan.map((d) => Padding(padding: const EdgeInsets.only(bottom:12), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: AppColors.cardShadow), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[Text(d.title, style: AppTextStyles.h3), ElevatedButton(onPressed: () => _showEditDay(d), style: ElevatedButton.styleFrom(backgroundColor: AppColors.red), child: const Text('Edit'))]),
        const SizedBox(height:8),
        ...d.exercises.map((e) => Padding(padding: const EdgeInsets.symmetric(vertical:6), child: Row(children:[Flexible(child: Text(e['name'] ?? '', style: AppTextStyles.body, overflow: TextOverflow.ellipsis)), const SizedBox(width:8), Text('${e['sets'] ?? ''} x ${e['reps'] ?? ''}', style: AppTextStyles.caption)]))),
        const SizedBox(height:8),
        Row(children:[ElevatedButton(onPressed: () => _completeDay(d), child: const Text('Complete Day')), const SizedBox(width:8), Text(_completed.contains(d.id) ? 'Completed' : '')])
      ])))) .toList();
    } catch (e, st) {
      debugPrint('Error building plan widgets: $e\n$st');
      return [Padding(padding: const EdgeInsets.all(16), child: Text('Failed to render plan: $e', style: AppTextStyles.caption))];
    }
  }

  // month name helper removed — unused in redesigned UI

  // ignore: unused_element
  Widget _buildGoalSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("🔻  LOSE WEIGHT", style: AppTextStyles.labelRed),
              Text("Target: June 15, 2025", style: AppTextStyles.caption.copyWith(color: AppColors.black)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("78.5 kg", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.black)),
              Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: const [
                      Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
                      Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.divider),
                    ],
                  ),
                ),
              ),
              Text("72.0 kg", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.black)),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.65,
              backgroundColor: Color(0xFFE0E0E0),
              valueColor: AlwaysStoppedAnimation(AppColors.red),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text("65% to goal", style: AppTextStyles.caption),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildWorkoutList(String img, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(img, width: 48, height: 48, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              gradient: AppColors.redGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
