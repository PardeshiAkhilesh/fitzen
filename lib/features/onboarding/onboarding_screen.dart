import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'onboarding_controller.dart';
import 'onboarding_steps.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/orange_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingController(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Progress Bar Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      if (controller.currentIndex > 0)
                        GestureDetector(
                          onTap: controller.previousStep,
                          child: const Icon(Icons.arrow_back, color: AppColors.orange),
                        )
                      else
                        const SizedBox(width: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: (controller.currentIndex + 1) / controller.totalSteps,
                            minHeight: 6,
                            color: AppColors.orange,
                            backgroundColor: const Color(0xFF2A2A2A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Step ${controller.currentIndex + 1} of 11",
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                
                // PageView for steps
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      StepGender(c: controller),
                      StepAge(c: controller),
                      StepHeight(c: controller),
                      StepWeight(c: controller),
                      StepActivity(c: controller),
                      StepGoalType(c: controller),
                      StepTargetWeight(c: controller),
                      StepWeeklyRate(c: controller),
                      StepCalories(c: controller),
                      StepMacros(c: controller),
                      StepWater(c: controller),
                    ],
                  ),
                ),
                
                // Bottom Button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: OrangeButton(
                    text: "Continue →",
                    onPressed: () => controller.nextStep(context),
                  ),
                ),
              ],
            ),
            
            // Loading Overlay
            if (controller.isLoading)
              Container(
                color: const Color(0x99000000),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: AppColors.orange),
                      const SizedBox(height: 12),
                      Text("Setting up your profile...", style: AppTextStyles.caption.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
