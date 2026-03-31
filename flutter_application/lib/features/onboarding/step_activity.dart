import 'package:flutter/material.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/hero_image_card.dart';

class StepActivity extends StatefulWidget {
  final VoidCallback onNext;
  final ValueChanged<String> onActivityChanged;
  const StepActivity({super.key, required this.onNext, required this.onActivityChanged});

  @override
  State<StepActivity> createState() => _StepActivityState();
}

class _StepActivityState extends State<StepActivity> {
  int _selectedActivity = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeroImageCard(
          imageUrl: AppImages.activityBanner,
          height: 220,
          borderRadius: 0,
          overlay: AppColors.imageOverlayRed,
          content: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("How active are you?", style: AppTextStyles.h1White),
                Text("Shapes your daily calorie targets", style: AppTextStyles.captionWhite),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildCard(0, "🛋️", "Sedentary", "Little to no exercise"),
              const SizedBox(height: 10),
              _buildCard(1, "🚶", "Light", "Exercise 1-3 times/week"),
              const SizedBox(height: 10),
              _buildCard(2, "🏃", "Moderate", "Exercise 4-5 times/week"),
              const SizedBox(height: 10),
              _buildCard(3, "🏋️", "Heavy", "Daily heavy exercise"),
              const SizedBox(height: 10),
              _buildCard(4, "🔥", "Athlete", "2x daily workouts"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(int index, String emoji, String title, String subtitle) {
    final isSelected = _selectedActivity == index;
    final activityLevels = ['sedentary', 'light', 'moderate', 'active', 'very_active'];
    return GestureDetector(
      onTap: () {
        setState(() => _selectedActivity = index);
        widget.onActivityChanged(activityLevels[index]);
      },
      child: Container(
        height: 90,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromRGBO(232, 25, 27, 0.04) : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.red : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [] : AppColors.cardShadow,
        ),
        child: Row(
          children: [
            if (isSelected)
              Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                ),
              )
            else
              const SizedBox(width: 4),
            const SizedBox(width: 16),
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: AppTextStyles.h3),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.red, size: 24),
          ],
        ),
      ),
    );
  }
}
