import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/hero_image_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ["All", "Running", "Cycling", "Zumba"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
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
                              color: Colors.white.withOpacity(0.2),
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
                      child: Text("Log food or workout...", style: AppTextStyles.caption.copyWith(fontSize: 14)),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        gradient: AppColors.redGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward, color: AppColors.white, size: 20),
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
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
            child: Center(child: Text("JD", style: AppTextStyles.h2White)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("HI JAMES 👋", style: AppTextStyles.h1),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("May 2024", style: AppTextStyles.h3),
              const Row(
                children: [
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
                final date = 15 + index;
                final isToday = date == 18;
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
                          color: isToday ? AppColors.red : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            date.toString(),
                            style: isToday ? AppTextStyles.bodyWhiteBold : AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
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
            percent: 258 / 430,
            startAngle: 180.0,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: AppColors.red,
            backgroundColor: const Color(0xFFE0E0E0),
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("258", style: AppTextStyles.display.copyWith(fontSize: 56)),
                Text("Kcal", style: AppTextStyles.labelRed),
                Text("Burned", style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statChip("Target", "430"),
              Container(height: 30, width: 1, color: AppColors.red),
              _statChip("Food", "222 Kcal"),
              Container(height: 30, width: 1, color: AppColors.red),
              _statChip("Rest", "90"),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _macroCard("Protein", AppColors.protein, 45, 150),
          const SizedBox(width: 8),
          _macroCard("Carbs", AppColors.carbs, 80, 200),
          const SizedBox(width: 8),
          _macroCard("Fat", AppColors.fat, 20, 65),
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
    return Container(
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
              Text("5 / 8", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.black)),
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
            children: List.generate(8, (index) {
              return Icon(
                index < 5 ? Icons.water_drop : Icons.water_drop_outlined,
                color: index < 5 ? const Color(0xFF2979FF) : AppColors.divider,
                size: 28,
              );
            }),
          ),
        ],
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
          _logCard(AppImages.breakfastImg, "Scrambled Eggs", "+320 kcal", true, "P:22g · C:3g · F:18g"),
          const SizedBox(height: 12),
          _logCard(AppImages.zumbaThumb, "Zumba Class", "-410 kcal", false, ""),
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
