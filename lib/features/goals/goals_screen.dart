import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HeroImageCard(
              imageUrl: AppImages.trainerHero,
              height: 240,
              borderRadius: 0,
              overlay: const LinearGradient(
                colors: [Color(0xFF000000), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.orange,
                        child: Text("AI"), // Or cache trainer image
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your Coach", style: AppTextStyles.caption),
                          Text("AI MacroMind", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 40, height: 40,
                        decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_outward, color: Colors.white),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Make Your Body", style: AppTextStyles.h1),
                        Text("Stronger 💪", style: AppTextStyles.h1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Goal summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("🔻 LOSE WEIGHT", style: AppTextStyles.labelOrange.copyWith(color: AppColors.orange)),
                          Text("Target: June 15, 2025", style: AppTextStyles.caption),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("78.5 kg", style: AppTextStyles.h3),
                          Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 16), height: 1, color: AppColors.divider)),
                          Text("72.0 kg", style: AppTextStyles.h3),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(value: 0.65, color: AppColors.orange, backgroundColor: AppColors.scaffoldBg, minHeight: 6),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                Text("Suggested Courses", style: AppTextStyles.h2),
                const SizedBox(height: 16),
                
                _buildCourseRow(AppImages.pushUpThumb, "Push Up Training", "Increase your strength", false),
                _buildCourseRow(AppImages.fullBodyThumb, "Full Body Workout", "Exercise and target your body", true),
                _buildCourseRow(AppImages.hardTrainThumb, "Hard Training", "Maximize your training", false),
                
                const SizedBox(height: 24),
                Container(
                  height: 56,
                  decoration: BoxDecoration(gradient: AppColors.orangeGradient, borderRadius: BorderRadius.circular(16)),
                  child: Center(child: Text("Start Course", style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold))),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseRow(String img, String title, String sub, bool hl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: CachedNetworkImage(imageUrl: img, width: 48, height: 48, fit: BoxFit.cover)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                  Text(sub, style: AppTextStyles.caption.copyWith(color: hl ? AppColors.orange : AppColors.textSecondary)),
                ],
              ),
            ),
            Container(
              width: 40, height: 40,
              decoration: const BoxDecoration(gradient: AppColors.orangeGradient, shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
