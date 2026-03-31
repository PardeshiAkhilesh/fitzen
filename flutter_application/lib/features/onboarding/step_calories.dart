import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StepCalories extends StatefulWidget {
  final VoidCallback onNext;
  final ValueChanged<int> onCaloriesChanged;
  const StepCalories({super.key, required this.onNext, required this.onCaloriesChanged});

  @override
  State<StepCalories> createState() => _StepCaloriesState();
}

class _StepCaloriesState extends State<StepCalories> {
  double _calories = 2150.0;

  @override
  Widget build(BuildContext context) {
    bool isLow = _calories < 1200;

    return Column(
      children: [
        const SizedBox(height: 40),
        Text("Daily Calories", style: AppTextStyles.h1),
        const SizedBox(height: 40),
        
        Container(
          width: 250,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppColors.redShadow,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("⭐ AI Recommended", style: AppTextStyles.labelWhite.copyWith(fontSize: 10)),
              ),
              const SizedBox(height: 16),
              Text(_calories.toInt().toString(), style: AppTextStyles.display.copyWith(fontSize: 72)),
              Text("kcal / day", style: AppTextStyles.labelRed),
            ],
          ),
        ),
        
        const SizedBox(height: 60),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.red,
              inactiveTrackColor: const Color(0xFFE0E0E0),
              thumbColor: AppColors.red,
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            ),
            child: Slider(
              value: _calories,
              min: 1000,
              max: 4000,
              divisions: 300,
              onChanged: (val) {
                setState(() => _calories = val);
                widget.onCaloriesChanged(val.toInt());
              },
            ),
          ),
        ),
        
        if (isLow)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0x1AFFC107),
                border: Border.all(color: AppColors.warning),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                  SizedBox(width: 8),
                  Expanded(child: Text("⚠️ Very low calories can be harmful")),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
