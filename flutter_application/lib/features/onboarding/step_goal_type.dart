import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/hero_image_card.dart';

class StepGoalType extends StatefulWidget {
  final VoidCallback onNext;
  final ValueChanged<String> onGoalTypeChanged;
  const StepGoalType({super.key, required this.onNext, required this.onGoalTypeChanged});

  @override
  State<StepGoalType> createState() => _StepGoalTypeState();
}

class _StepGoalTypeState extends State<StepGoalType> {
  int _selectedGoal = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeroImageCard(
          imageUrl: AppImages.fullBodyWorkout,
          height: 220,
          borderRadius: 0,
          overlay: AppColors.imageOverlayRed,
          content: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("What's your goal?", style: AppTextStyles.h1White),
                Text("We'll customise everything for you", style: AppTextStyles.captionWhite),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildCard(0, "🔻", "Lose Weight", "Burn fat, slim down to your ideal weight", AppImages.cardioWorkout),
              const SizedBox(height: 12),
              _buildCard(1, "💪", "Build Muscle", "Increase mass and strength", AppImages.upperBodyWorkout),
              const SizedBox(height: 12),
              _buildCard(2, "⚖️", "Maintain Weight", "Stay healthy and fit", AppImages.fullBodyWorkout),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(int index, String emoji, String title, String subtitle, String imgUrl) {
    final isSelected = _selectedGoal == index;
    final goalTypes = ['lose', 'gain', 'maintain'];
    return GestureDetector(
      onTap: () {
        setState(() => _selectedGoal = index);
        widget.onGoalTypeChanged(goalTypes[index]);
      },
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(16),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(title, style: AppTextStyles.h3),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isSelected)
                  const Positioned(
                    top: -4,
                    right: -4,
                    child: Icon(Icons.check_circle, color: AppColors.red, size: 24),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
