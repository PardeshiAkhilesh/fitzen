import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:dio/dio.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/hero_image_card.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../../core/models/daily_nutrition.dart';
import '../../core/models/water_status.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ["All", "Running", "Cycling", "Zumba"];
  
  DailyNutrition? _nutrition;
  WaterStatus? _waterStatus;
  List<Map<String, dynamic>> _todayLogs = [];
  bool _isLoading = true;
  String? _userName;
  final _llmController = TextEditingController();
  bool _isLogging = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _loadUserName();
  }

  @override
  void dispose() {
    _llmController.dispose();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    try {
      final data = await ApiService.get(ApiConstants.me);
      if (mounted) setState(() => _userName = data['full_name'] ?? 'User');
    } catch (_) {}
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      debugPrint('DEBUG: Starting to load dashboard data...');
      final results = await Future.wait([
        ApiService.get(ApiConstants.foodOrWorkoutToday),
        ApiService.get(ApiConstants.waterToday),
        ApiService.get(ApiConstants.foodOrWorkoutLogsToday),
      ]);

      debugPrint('DEBUG: API Results received');
      debugPrint('DEBUG: Nutrition data: ${results[0]}');
      debugPrint('DEBUG: Water data: ${results[1]}');
      debugPrint('DEBUG: Logs data: ${results[2]}');

      if (mounted) {
        setState(() {
          _nutrition = DailyNutrition.fromJson(results[0]);
          debugPrint('DEBUG: Nutrition parsed - date: ${_nutrition?.date.toIso8601String()}, Consumed: ${_nutrition?.consumedCalories}, Protein: ${_nutrition?.consumedProtein}');
          
          _waterStatus = WaterStatus.fromJson(results[1]);
          debugPrint('DEBUG: Water parsed - ${_waterStatus?.consumedGlasses}/${_waterStatus?.targetGlasses}');
          
          // Handle logs data - it should be a list
          _todayLogs = [];
          try {
            final logsData = results[2] as List;
            debugPrint('DEBUG: Logs data received: $logsData');
            for (var item in logsData) {
              if (item is Map<String, dynamic>) {
                debugPrint('DEBUG: Log item: $item');
                _todayLogs.add(item);
              }
            }
            debugPrint('DEBUG: Total logs added: ${_todayLogs.length}');
          } catch (e) {
            debugPrint('DEBUG: Error parsing logs: $e');
          }
          
          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      debugPrint('DEBUG: DioException: ${e.response?.data}');
      if (mounted) {
        setState(() => _isLoading = false);
        final detail = e.response?.data ?? e.message;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load dashboard: $detail'), backgroundColor: AppColors.red));
      }
    } catch (e) {
      debugPrint('DEBUG: General error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load dashboard: $e'), backgroundColor: AppColors.red));
      }
    }
  }

  Future<void> _addWaterGlass() async {
    try {
      await ApiService.post(ApiConstants.waterAddGlass, {});
      final waterData = await ApiService.get(ApiConstants.waterToday);
      if (mounted) {
        setState(() => _waterStatus = WaterStatus.fromJson(waterData));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please set your water goal first')),
        );
      }
    }
  }

  Future<void> _handleLlmLog() async {
    final text = _llmController.text.trim();
    if (text.isEmpty) return;

    debugPrint('DEBUG: Logging text: $text');
    setState(() => _isLogging = true);

    try {
      final result = await ApiService.post(ApiConstants.llmLog, {'text': text});
      debugPrint('DEBUG: LLM Log result: $result');
      _llmController.clear();

      // Wait a moment for backend to process
      await Future.delayed(const Duration(milliseconds: 500));
      
      debugPrint('DEBUG: Refreshing dashboard data...');
      await _loadDashboardData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged! ${result['llm_result']?['intent'] == 'exercise' ? '🏋️ Workout' : '🍽️ Food'} tracked.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } on DioException catch (e) {
      debugPrint('DEBUG: LLM Log error: ${e.response?.data}');
      final detail = e.response?.data?['detail'] ?? 'Logging failed';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(detail.toString()), backgroundColor: AppColors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLogging = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.red))
          : SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 100), // Space for AI bar
              children: [
                _buildHeader(),
                _buildDateStrip(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HeroImageCard(
                    imageUrl: AppImages.challengeBanner,
                    height: 115,
                    borderRadius: 20,
                    overlay: AppColors.imageOverlayRed,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              color: const Color(0x33FFFFFF),
                              child: Text(
                                "TODAY'S CHALLENGE", 
                                style: AppTextStyles.labelWhite.copyWith(fontSize: 10, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text("Do your plan before 9:00 PM", style: AppTextStyles.bodyWhiteBold),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildFilterChips(),
                const SizedBox(height: 16),
                _buildStepsGoalsRow(),
                const SizedBox(height: 24),
                _buildCalorieRing(),
                const SizedBox(height: 16),
                _buildNutritionSummaryCard(),
                const SizedBox(height: 24),
                _buildMacrosRow(),
                const SizedBox(height: 32),
                _buildYourPlan(),
                const SizedBox(height: 32),
                _buildWaterTracker(),
                const SizedBox(height: 32),
                _buildFoodWorkoutLogs(),
              ],
            ),
            
            // AI Input Bar Pinned to bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: AppColors.cardShadow,
                  border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.mic_rounded, color: AppColors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _llmController,
                        style: AppTextStyles.caption.copyWith(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Log food or workout...",
                          hintStyle: AppTextStyles.caption.copyWith(fontSize: 14),
                          border: InputBorder.none,
                          filled: false,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _isLogging ? null : _handleLlmLog,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          gradient: AppColors.redGradient,
                          shape: BoxShape.circle,
                        ),
                        child: _isLogging
                            ? const Center(child: SizedBox(width: 20, height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
                            : const Icon(Icons.arrow_forward, color: AppColors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final initials = _userName?.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join() ?? 'U';
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
            child: Center(child: Text(initials, style: AppTextStyles.h2White)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("HI ${_userName?.toUpperCase() ?? 'THERE'} 👋", style: AppTextStyles.h1),
              Row(
                children: [
                  const Text("✦ ", style: TextStyle(color: AppColors.red)),
                  Text("Elite Fit Member", style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
          const SizedBox(width: 16),
          const Icon(Icons.more_vert, color: AppColors.textPrimary),
        ],
      ),
    );
  }

  Widget _buildDateStrip() {
    final base = _nutrition?.date ?? DateTime.now();
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final monthYear = '${monthNames[base.month - 1]} ${base.year}';

    // Build a 7-day window centered on base date
    final days = List.generate(7, (i) => base.add(Duration(days: i - 3)));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(monthYear, style: AppTextStyles.h3),
              Row(
                children: const [
                  Icon(Icons.chevron_left),
                  SizedBox(width: 16),
                  Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(7, (index) {
                final d = days[index];
                final isSelected = d.day == base.day && d.month == base.month && d.year == base.year;
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Text(["M", "T", "W", "T", "F", "S", "S"][index], style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.red : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            d.day.toString(),
                            style: isSelected ? AppTextStyles.bodyWhiteBold : AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isSelected = _selectedFilter == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.redGradient : null,
                color: isSelected ? null : AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: isSelected ? null : Border.all(color: AppColors.divider),
              ),
              child: Text(
                _filters[index],
                style: isSelected ? AppTextStyles.labelWhite : AppTextStyles.caption.copyWith(color: AppColors.medGray, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepsGoalsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("👟"),
                  const SizedBox(height: 8),
                  Text("1,840 steps", style: AppTextStyles.h3),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("🎯 My Goals  ", style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(gradient: AppColors.redGradient, borderRadius: BorderRadius.circular(20)),
                        child: Text("Start →", style: AppTextStyles.labelWhite.copyWith(fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("2 of 3 completed", style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieRing() {
    final consumed = _nutrition?.consumedCalories ?? 0;
    final burned = _nutrition?.burnedCalories ?? 0;
    final remaining = _nutrition?.remainingCalories ?? 0;
    final total = consumed + remaining;
    final percent = total > 0 ? (burned / total).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 100.0,
            lineWidth: 16.0,
            animation: true,
            animationDuration: 1500,
            percent: percent,
            startAngle: 180.0,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: AppColors.red,
            backgroundColor: const Color(0xFFE0E0E0),
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(burned.toInt().toString(), style: AppTextStyles.display.copyWith(fontSize: 56)),
                Text("Kcal", style: AppTextStyles.labelRed),
                Text("Burned", style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statChip("Target", total.toInt().toString()),
              Container(height: 30, width: 1, color: AppColors.red),
              _statChip("Food", "${consumed.toInt()} Kcal"),
              Container(height: 30, width: 1, color: AppColors.red),
              _statChip("Rest", remaining.toInt().toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String val) {
    return Column(
      children: [
        Text(val, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.black)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildMacrosRow() {
    final protein = _nutrition?.consumedProtein.toInt() ?? 0;
    final proteinTotal = (_nutrition?.consumedProtein ?? 0) + (_nutrition?.remainingProtein ?? 1);
    final carbs = _nutrition?.consumedCarbs.toInt() ?? 0;
    final carbsTotal = (_nutrition?.consumedCarbs ?? 0) + (_nutrition?.remainingCarbs ?? 1);
    final fat = _nutrition?.consumedFat.toInt() ?? 0;
    final fatTotal = (_nutrition?.consumedFat ?? 0) + (_nutrition?.remainingFat ?? 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _macroCard("Protein", AppColors.protein, protein, proteinTotal.toInt()),
          const SizedBox(width: 8),
          _macroCard("Carbs", AppColors.carbs, carbs, carbsTotal.toInt()),
          const SizedBox(width: 8),
          _macroCard("Fat", AppColors.fat, fat, fatTotal.toInt()),
        ],
      ),
    );
  }

  Widget _buildNutritionSummaryCard() {
    final kcal = _nutrition?.consumedCalories.toInt() ?? 0;
    final protein = _nutrition?.consumedProtein.toInt() ?? 0;
    final carbs = _nutrition?.consumedCarbs.toInt() ?? 0;
    final fat = _nutrition?.consumedFat.toInt() ?? 0;
    Widget tile(String label, String value, Color color, IconData icon, double width) {
      return SizedBox(
        width: width,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppColors.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value, style: AppTextStyles.h3.copyWith(fontSize: 14)),
                    Text(label, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final width = MediaQuery.of(context).size.width;
    // Compute tile width so that on narrow screens we show 2 per row, otherwise 4 in a row
    final horizontalPadding = 32.0; // 16 left + 16 right
    final spacing = 8.0;
    final available = width - horizontalPadding - (spacing * 3);
    final tileWidth = available / (width < 420 ? 2 : 4);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: spacing,
        runSpacing: 8,
        children: [
          tile("Calories", "$kcal kcal", AppColors.red, Icons.local_fire_department, tileWidth),
          tile("Protein", "${protein}g", AppColors.protein, Icons.emoji_food_beverage, tileWidth),
          tile("Carbs", "${carbs}g", AppColors.carbs, Icons.food_bank, tileWidth),
          tile("Fat", "${fat}g", AppColors.fat, Icons.opacity, tileWidth),
        ],
      ),
    );
  }

  Widget _macroCard(String title, Color color, int current, int target) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text(title, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.black)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: current / target,
                backgroundColor: const Color(0xFFE0E0E0),
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Text("$current / ${target}g", style: AppTextStyles.caption.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildYourPlan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your Plan", style: AppTextStyles.h2),
          const SizedBox(height: 16),
          HeroImageCard(
            imageUrl: AppImages.progressCard,
            height: 165,
            borderRadius: 20,
            overlay: const LinearGradient(
              colors: [Color(0x33000000), Color(0xBB000000)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
            content: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(20)),
                    child: Text("Progress", style: AppTextStyles.labelWhite),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Lower Body", style: AppTextStyles.h2White),
                      Text("Cardio 10 mins", style: AppTextStyles.captionWhite70),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Start", style: AppTextStyles.labelRed.copyWith(fontSize: 13, color: AppColors.red)),
                            const SizedBox(width: 4),
                            const Icon(Icons.play_circle_filled, color: AppColors.red, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _workoutListCard(AppImages.lowerBodyWorkout, "Lower body workout", "Glutes / Squads", "30 mins"),
          const SizedBox(height: 12),
          _workoutListCard(AppImages.cardioWorkout, "Cardio Session", "Full Body Fat Burn", "20 mins"),
        ],
      ),
    );
  }

  Widget _workoutListCard(String img, String title, String subtitle, String duration) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: CachedNetworkImage(imageUrl: img, width: 100, height: 100, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: AppTextStyles.h3.copyWith(fontSize: 15)),
                  Text(subtitle, style: AppTextStyles.caption),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(12)),
                        child: Text(duration, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.black)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(gradient: AppColors.redGradient, borderRadius: BorderRadius.circular(20)),
              child: Text("Start", style: AppTextStyles.labelWhite.copyWith(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterTracker() {
    final consumed = _waterStatus?.consumedGlasses ?? 0;
    final target = _waterStatus?.targetGlasses ?? 8;

    return GestureDetector(
      onTap: _addWaterGlass,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("💧 Water Intake", style: AppTextStyles.h3),
                const Spacer(),
                Text("$consumed / $target", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.black)),
                const SizedBox(width: 12),
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(gradient: AppColors.redGradient, shape: BoxShape.circle),
                  child: const Icon(Icons.add, color: AppColors.white, size: 20),
                )
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List.generate(target, (index) {
                return Icon(
                  index < consumed ? Icons.water_drop : Icons.water_drop_outlined,
                  color: index < consumed ? const Color(0xFF2979FF) : AppColors.divider,
                  size: 28,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodWorkoutLogs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Today's Logs", style: AppTextStyles.h2),
              const Spacer(),
              Text("View All →", style: AppTextStyles.labelRed),
            ],
          ),
          const SizedBox(height: 16),
          if (_todayLogs.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text("No logs yet. Use the AI bar below to log food or workout!", 
                    style: AppTextStyles.caption, textAlign: TextAlign.center),
              ),
            )
          else
            ..._todayLogs.take(5).map((log) {
              final isFood = log['type'] == 'food';
              final name = log['name']?.toString() ?? 'Unknown';
              final calories = (log['calories'] as num?)?.toDouble() ?? 0;
              final protein = (log['protein'] as num?)?.toDouble() ?? 0;
              final carbs = (log['carbs'] as num?)?.toDouble() ?? 0;
              final fat = (log['fat'] as num?)?.toDouble() ?? 0;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _logCard(
                  isFood ? AppImages.breakfastImg : AppImages.zumbaThumb,
                  name,
                  isFood 
                      ? '+${calories.round()} kcal'
                      : '-${calories.round()} kcal',
                  isFood,
                  isFood 
                      ? 'P:${protein.round()}g · C:${carbs.round()}g · F:${fat.round()}g'
                      : '',
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _logCard(String img, String title, String kcal, bool isFood, String macro) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: isFood ? AppColors.red : AppColors.protein,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(imageUrl: img, width: 48, height: 48, fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.black)),
                    const Spacer(),
                    Text(kcal, style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.bold, 
                      color: isFood ? AppColors.red : AppColors.success,
                    )),
                    const SizedBox(width: 16),
                  ],
                ),
                if (macro.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(12)),
                    child: Text(macro, style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.black)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
