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
  bool isCompleted;
  bool isUnlocked;

  WorkoutDay({
    required this.id,
    required this.dayNumber,
    required this.dayLabel,
    required this.title,
    required this.exercises,
    this.isCompleted = false,
    this.isUnlocked = false,
  });
}

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<WorkoutDay> _plan = [];
  bool _loading = true;
  final Map<int, int> _burnResults = {};

  // Tracks which sets are checked per day per exercise
  // Key: dayId, Value: List<List<bool>> — outer = exercise index, inner = set index
  final Map<int, List<List<bool>>> _setChecks = {};

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  Future<void> _loadPlan() async {
    if (mounted) setState(() => _loading = true);
    try {
      final res = await ApiService.get(ApiConstants.workoutPlan);
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
        days.add(WorkoutDay(
          id: item['id'] ?? 0,
          dayNumber: item['day_number'] ?? 0,
          dayLabel: item['day_label'] ?? 'Day',
          title: item['title'] ?? 'Workout',
          exercises: exs,
          isCompleted: item['is_completed'] == true,
          isUnlocked: item['is_unlocked'] == true,
        ));
      }

      if (mounted) {
        setState(() {
          _plan = days;
          _setChecks.clear();
          for (var d in _plan) {
            _setChecks[d.id] = d.exercises.map((e) {
              final sets = int.tryParse(e['sets'] ?? '1') ?? 1;
              return List<bool>.filled(sets, false);
            }).toList();
          }
        });
      }
    } catch (e) {
      debugPrint('Failed loading plan: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _completeDay(WorkoutDay day) async {
    try {
      // 1. Mark completion in DB
      await ApiService.post(ApiConstants.workoutPlanCompleteDay, {'plan_id': day.id});

      // 2. Calculate calorie burn
      final exercises = day.exercises.map((e) {
        return {
          'name': e['name'],
          'sets': int.tryParse(e['sets'] ?? '') ?? 1,
          'reps': e['reps'] ?? '',
        };
      }).toList();
      final res = await ApiService.post(
        ApiConstants.workoutPlanCalculateBurn,
        {'day_title': day.title, 'exercises': exercises},
      );
      final cal = (res['total_calories'] as num?)?.toInt() ?? 0;

      if (!mounted) return;
      setState(() {
        day.isCompleted = true;
        _burnResults[day.id] = cal;
        // Unlock the next day
        final idx = _plan.indexWhere((d) => d.id == day.id);
        if (idx >= 0 && idx + 1 < _plan.length) {
          _plan[idx + 1].isUnlocked = true;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Day complete! ~$cal kcal burned 🔥')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  String _exerciseImageUrl(String name) {
    final key = name.toLowerCase().trim();
    
    // Chest / Push
    if (key.contains('bench') || key.contains('chest') || key.contains('push') || key.contains('fly') || key.contains('dip') || key.contains('incline')) {
      return 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=300&q=80';
    }
    // Back / Pull
    if (key.contains('deadlift') || key.contains('row') || key.contains('pull') || key.contains('lat') || key.contains('back')) {
      return 'https://images.unsplash.com/photo-1603287681836-b174ce5074c2?auto=format&fit=crop&w=300&q=80';
    }
    // Legs
    if (key.contains('squat') || key.contains('leg') || key.contains('calf') || key.contains('lung') || key.contains('thrust') || key.contains('romanian') || key.contains('bulgarian')) {
      return 'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?auto=format&fit=crop&w=300&q=80';
    }
    // Arms / Shoulders
    if (key.contains('curl') || key.contains('tricep') || key.contains('bicep') || key.contains('extension') || key.contains('pushdown') || key.contains('shoulder') || key.contains('raise') || key.contains('overhead') || key.contains('press')) {
      return 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?auto=format&fit=crop&w=300&q=80';
    }
    // Abs / Core
    if (key.contains('abs') || key.contains('plank') || key.contains('crunch') || key.contains('rollout') || key.contains('core')) {
      return 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=300&q=80';
    }

    // Default general gym premium photo
    return 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=300&q=80';
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
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          sb(() { 
                            exCtrls.add({
                              'name': TextEditingController(), 
                              'sets': TextEditingController(text: '3'), 
                              'reps': TextEditingController(text: '10')
                            }); 
                          }); 
                        }, 
                        child: const Text('Add Exercise')
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
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
                        }, 
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                        child: const Text('Save')
                      ),
                    ),
                  ])
                ]),
              );
            }),
          ),
        );
      }
    );
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

  bool _allSetsChecked(WorkoutDay day) {
    final checks = _setChecks[day.id];
    if (checks == null) return false;
    return checks.every((exSets) => exSets.every((v) => v));
  }

  int _checkedCount(WorkoutDay day) {
    final checks = _setChecks[day.id];
    if (checks == null) return 0;
    int c = 0;
    for (var ex in checks) {
      if (ex.every((v) => v)) c++;
    }
    return c;
  }

  @override
  Widget build(BuildContext context) {
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
                await ApiService.post(ApiConstants.workoutPlanReset, {});
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
                            await ApiService.post(ApiConstants.workoutPlanReset, {});
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
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _plan.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: HeroImageCard(
                          imageUrl: AppImages.trainerHero,
                          height: 220,
                          overlay: AppColors.imageOverlayDark,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, 
                            mainAxisAlignment: MainAxisAlignment.end, 
                            children: [
                              Text('Your Coach', style: AppTextStyles.captionWhite70), 
                              Text('Elite Fit AI', style: AppTextStyles.labelWhite)
                            ]
                          ),
                        ),
                      );
                    }
                    final day = _plan[index - 1];
                    
                    if (!day.isUnlocked) {
                      return _buildLockedDayCard(day);
                    }
                    if (day.isCompleted) {
                      return _buildCompletedDayCard(day);
                    }
                    return _buildActiveDayCard(day);
                  },
                ),
    );
  }

  Widget _buildLockedDayCard(WorkoutDay day) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(children: [
        const Icon(Icons.lock_outline, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(day.dayLabel, style: AppTextStyles.caption),
            Text(day.title, style: AppTextStyles.h3.copyWith(color: Colors.grey), overflow: TextOverflow.ellipsis),
          ]),
        ),
      ]),
    );
  }

  Widget _buildCompletedDayCard(WorkoutDay day) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade300, width: 2),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(day.dayLabel, style: AppTextStyles.caption),
                    Text(day.title, style: AppTextStyles.h3, overflow: TextOverflow.ellipsis),
                  ]
                )
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text('Completed', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          if (_burnResults.containsKey(day.id)) ...[
            Text('~${_burnResults[day.id]} kcal burned 🔥', style: AppTextStyles.caption.copyWith(color: AppColors.red, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
          ],
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),
          ...day.exercises.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.grey, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(e['name'] ?? '', style: AppTextStyles.body.copyWith(color: Colors.grey), overflow: TextOverflow.ellipsis),
                  ),
                  Text('${e['sets'] ?? ''} x ${e['reps'] ?? ''}', style: AppTextStyles.caption),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActiveDayCard(WorkoutDay day) {
    final isReady = _allSetsChecked(day);
    final completedExs = _checkedCount(day);
    final totalExs = day.exercises.length;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(day.dayLabel, style: AppTextStyles.caption),
                    Text(day.title, style: AppTextStyles.h3, overflow: TextOverflow.ellipsis),
                  ]
                )
              ),
              TextButton(
                onPressed: () => _showEditDay(day),
                child: const Text('Edit'),
              )
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(day.exercises.length, (exIdx) {
            final e = day.exercises[exIdx];
            final setCount = int.tryParse(e['sets'] ?? '1') ?? 1;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _exerciseImageUrl(e['name'] ?? ''),
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 52, height: 52,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.fitness_center, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(e['name'] ?? '', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 8),
                            Text('x ${e['reps'] ?? ''}', style: AppTextStyles.caption),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_setChecks.containsKey(day.id) && _setChecks[day.id]!.length > exIdx)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(setCount, (setIdx) {
                              if (_setChecks[day.id]![exIdx].length <= setIdx) return const SizedBox.shrink();
                              final checked = _setChecks[day.id]![exIdx][setIdx];
                              return GestureDetector(
                                onTap: () => setState(() {
                                  _setChecks[day.id]![exIdx][setIdx] = !checked;
                                }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: checked ? AppColors.red : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: checked ? AppColors.red : Colors.grey.shade400),
                                  ),
                                  child: Text(
                                    'Set ${setIdx + 1}',
                                    style: AppTextStyles.caption.copyWith(
                                      color: checked ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '$completedExs / $totalExs exercises fully done',
              style: AppTextStyles.caption,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: isReady ? () => _completeDay(day) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isReady ? AppColors.red : Colors.grey.shade300,
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade600,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Complete Day'),
          ),
        ],
      ),
    );
  }
}
