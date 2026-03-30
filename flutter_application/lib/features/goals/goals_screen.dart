import 'package:flutter/material.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/hero_image_card.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('My Goals'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          HeroImageCard(
            imageUrl: AppImages.trainerHero,
            height: 240,
            overlay: AppColors.imageOverlayDark,
            content: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 22, 
                        backgroundImage: NetworkImage(AppImages.trainerHero)
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your Coach", style: AppTextStyles.captionWhite70),
                          Text("Elite Fit AI", style: AppTextStyles.labelWhite),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: AppColors.red, shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_outward, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Make Your Body", style: AppTextStyles.h1White),
                      Text("Stronger 💪", style: AppTextStyles.h1White),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildGoalSummaryCard(),
          const SizedBox(height: 32),
          Text("Suggested Workouts", style: AppTextStyles.h2),
          const SizedBox(height: 16),
          _buildWorkoutList(AppImages.pushUpThumb, "Push Up Training", "Increase your strength..."),
          const SizedBox(height: 12),
          _buildWorkoutList(AppImages.fullBodyThumb, "Full Body Workout", "Exercise and target your body"),
          const SizedBox(height: 12),
          _buildWorkoutList(AppImages.hardTrainThumb, "Hard Training", "Maximize with intense sets"),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.redGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.redShadow,
            ),
            child: Center(
              child: Text("Start Course", style: AppTextStyles.h3White),
            ),
          )
        ],
      ),
    );
  }

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
            children: [
              Text("🔻  LOSE WEIGHT", style: AppTextStyles.labelRed),
              const Spacer(),
              Text("Target: June 15, 2025", style: AppTextStyles.caption.copyWith(color: AppColors.black)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("78.5 kg", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.black)),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
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
