import 'package:flutter/material.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/hero_image_card.dart';

class StepGender extends StatefulWidget {
  final VoidCallback onNext;
  const StepGender({super.key, required this.onNext});

  @override
  State<StepGender> createState() => _StepGenderState();
}

class _StepGenderState extends State<StepGender> {
  String _selectedGender = 'male';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: HeroImageCard(
            key: ValueKey(_selectedGender),
            imageUrl: _selectedGender == 'male'
                ? AppImages.onboardingMale
                : _selectedGender == 'female'
                    ? AppImages.onboardingFemale
                    : AppImages.activityBanner,
            height: 240,
            borderRadius: 0,
            overlay: AppColors.imageOverlayDark,
            content: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("What's your", style: AppTextStyles.h2White),
                  Text("gender?", style: AppTextStyles.displayWhite),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildGenderCard('male', '👨  Male'),
              const SizedBox(height: 12),
              _buildGenderCard('female', '👩  Female'),
              const SizedBox(height: 12),
              _buildGenderCard('other', '🧑  Other'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderCard(String value, String title) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: Container(
        height: 72,
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
            Expanded(
              child: Text(title, style: AppTextStyles.h3),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.check_circle, color: AppColors.red, size: 24),
              ),
          ],
        ),
      ),
    );
  }
}
