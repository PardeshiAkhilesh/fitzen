import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class MacroRingCard extends StatelessWidget {
  final String title;
  final double percent;
  final Color color;
  final String currentValue;
  final String targetValue;

  const MacroRingCard({
    super.key,
    required this.title,
    required this.percent,
    required this.color,
    required this.currentValue,
    required this.targetValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 56.0,
          lineWidth: 8.0,
          animation: true,
          percent: percent.clamp(0.0, 1.0),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: color,
          backgroundColor: const Color(0xFF2A2A2A),
          center: Text(
            targetValue,
            style: AppTextStyles.h3.copyWith(fontSize: 16),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$currentValue / $targetValue',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
