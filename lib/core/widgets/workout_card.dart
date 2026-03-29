import 'package:flutter/material.dart';
import 'hero_image_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class WorkoutCard extends StatelessWidget {
  final String imageUrl;
  final String duration;
  final String title;
  final String subtitle;
  final VoidCallback onStart;

  const WorkoutCard({
    super.key,
    required this.imageUrl,
    required this.duration,
    required this.title,
    required this.subtitle,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: HeroImageCard(
        imageUrl: imageUrl,
        height: 130,
        borderRadius: 16,
        overlay: AppColors.imageOverlay,
        content: Stack(
          children: [
            // Duration badge
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xCC1A1A1A),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(duration, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                    Text('mins', style: AppTextStyles.caption.copyWith(fontSize: 10)),
                  ],
                ),
              ),
            ),
            // Workout info
            Positioned(
              bottom: 0,
              left: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h3),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            // Start button
            Positioned(
              bottom: 0,
              right: 0,
              child: ElevatedButton.icon(
                onPressed: onStart,
                icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                label: Text(
                  "Start",
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
