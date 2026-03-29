import 'package:flutter/material.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/hero_image_card.dart';
import '../../core/widgets/macro_ring_card.dart';
import '../../core/widgets/workout_card.dart';

// Dashboard widgets (included here for brevity)
import 'widgets/calorie_ring_widget.dart';
import 'widgets/ai_input_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeader(context),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 16),
                    _buildDateStrip(),
                    const SizedBox(height: 24),
                    _buildChallengeBanner(),
                    const SizedBox(height: 24),
                    const CalorieRingWidget(),
                    const SizedBox(height: 24),
                    _buildMacroRow(),
                    const SizedBox(height: 32),
                    _buildYourPlanHeader(),
                    const SizedBox(height: 16),
                    _buildProgressCard(),
                    const SizedBox(height: 16),
                    WorkoutCard(
                      imageUrl: AppImages.lowerBodyWorkout,
                      duration: '30',
                      title: 'Lower body workout',
                      subtitle: 'Glutes / Squads / Hamstrings',
                      onStart: () {},
                    ),
                    const SizedBox(height: 100), // padding for AI Input
                  ]),
                ),
              ),
            ],
          ),
          
          // AI Input pinned
          const Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: AiInputBar(),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 16, right: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
              child: Center(child: Text("JD", style: AppTextStyles.h3)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("HI JAMES 👋", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.orange, size: 14),
                      const SizedBox(width: 4),
                      Text("Fitness Tracker", style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildDateStrip() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final isToday = index == 3;
          return Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isToday ? AppColors.orange : AppColors.cardBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "${15 + index}",
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isToday ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChallengeBanner() {
    return HeroImageCard(
      imageUrl: AppImages.challengeBanner,
      height: 110,
      borderRadius: 20,
      overlay: AppColors.orangeImageOverlay,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Today's Challenge", style: AppTextStyles.h3),
              Text("Do your plan before 9:00 PM", style: AppTextStyles.caption.copyWith(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _MacroCard("Protein", 45, 150, AppColors.protein)),
        const SizedBox(width: 12),
        Expanded(child: _MacroCard("Carbs", 80, 200, AppColors.carbs)),
        const SizedBox(width: 12),
        Expanded(child: _MacroCard("Fat", 20, 65, AppColors.fat)),
      ],
    );
  }

  Widget _buildYourPlanHeader() {
    return Row(
      children: [
        Text("Your Plan", style: AppTextStyles.h2),
        const Spacer(),
        _filterChip("All", true),
        const SizedBox(width: 8),
        _filterChip("Lower body", false),
      ],
    );
  }

  Widget _filterChip(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.orange : Colors.transparent,
        border: active ? null : Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: active ? Colors.white : AppColors.textSecondary)),
    );
  }

  Widget _buildProgressCard() {
    return HeroImageCard(
      imageUrl: AppImages.progressCardFemale,
      height: 160,
      overlay: const LinearGradient(
        colors: [Color(0x88000000), Color(0x22000000)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(20)),
            child: Text("Progress", style: AppTextStyles.labelOrange.copyWith(color: Colors.white, fontSize: 10)),
          ),
          const SizedBox(height: 6),
          Text("Lower Body", style: AppTextStyles.h2),
          Text("Cardio 10 mins", style: AppTextStyles.caption),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_circle_filled, color: AppColors.orange),
            label: Text("Start", style: AppTextStyles.body.copyWith(color: AppColors.orange, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide.none,
              shape: const StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _MacroCard(String name, int val, int max, Color col) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: col, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(name, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: val / max, color: col, backgroundColor: AppColors.scaffoldBg, minHeight: 6),
          ),
          const SizedBox(height: 8),
          Text("$val / ${max}g", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}
