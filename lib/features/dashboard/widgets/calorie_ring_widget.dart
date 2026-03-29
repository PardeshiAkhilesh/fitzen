import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CalorieRingWidget extends StatelessWidget {
  const CalorieRingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 120.0,
          lineWidth: 16.0,
          animation: true,
          animationDuration: 1500,
          animateFromLastPercent: true,
          percent: 0.6,
          startAngle: 180.0,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: AppColors.orange,
          backgroundColor: const Color(0xFF2A2A2A),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("258", style: AppTextStyles.display.copyWith(fontSize: 56)),
              Text("Kcal", style: AppTextStyles.caption.copyWith(color: AppColors.orange)),
              Text("Burned", style: AppTextStyles.caption),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _statBlock("Target: 430", "Today's Goal"),
            Container(width: 1, height: 32, color: AppColors.divider, margin: const EdgeInsets.symmetric(horizontal: 16)),
            _statBlock("222 Kcal", "Consumed"),
            Container(width: 1, height: 32, color: AppColors.divider, margin: const EdgeInsets.symmetric(horizontal: 16)),
            _statBlock("Rest: 90", "Remaining"),
          ],
        ),
      ],
    );
  }

  Widget _statBlock(String val, String lbl) {
    return Column(
      children: [
        Text(val, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
        Text(lbl, style: AppTextStyles.caption),
      ],
    );
  }
}
