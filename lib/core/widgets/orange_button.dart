import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class OrangeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double borderRadius;
  final bool isTransparent;

  const OrangeButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 56,
    this.borderRadius = 14,
    this.isTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Ink(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: isTransparent ? null : AppColors.orangeGradient,
          border: isTransparent
              ? Border.all(color: AppColors.orange.withOpacity(0.5), width: 1.5)
              : null,
          color: isTransparent ? Colors.transparent : null,
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
