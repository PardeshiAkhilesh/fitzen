import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

import 'step_gender.dart';
import 'step_age.dart';
import 'step_height.dart';
import 'step_weight.dart';
import 'step_activity.dart';
import 'step_goal_type.dart';
import 'step_target_weight.dart';
import 'step_weekly_rate.dart';
import 'step_calories.dart';
import 'step_macros.dart';
import 'step_water.dart';

class OnboardingController extends StatefulWidget {
  const OnboardingController({super.key});

  @override
  State<OnboardingController> createState() => _OnboardingControllerState();
}

class _OnboardingControllerState extends State<OnboardingController> {
  final PageController _pageController = PageController();
  int _currentStep = 1;
  final int _totalSteps = 11;

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Mock completion -> go to dashboard
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          // PROGRESS BAR HEADER
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, statusBarHeight + 12, 16, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _prevStep,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _currentStep / _totalSteps,
                      backgroundColor: const Color(0xFFE0E0E0),
                      valueColor: const AlwaysStoppedAnimation(AppColors.red),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text("$_currentStep / $_totalSteps", style: AppTextStyles.caption),
              ],
            ),
          ),
          
          // PAGE VIEW
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index + 1;
                });
              },
              children: [
                StepGender(onNext: _nextStep),
                StepAge(onNext: _nextStep),
                StepHeight(onNext: _nextStep),
                StepWeight(onNext: _nextStep),
                StepActivity(onNext: _nextStep),
                StepGoalType(onNext: _nextStep),
                StepTargetWeight(onNext: _nextStep),
                StepWeeklyRate(onNext: _nextStep),
                StepCalories(onNext: _nextStep),
                StepMacros(onNext: _nextStep),
                StepWater(onNext: _nextStep),
              ],
            ),
          ),
          
          // BOTTOM CTA is handled within each step or could be pinned here.
          // The prompt says "pinned bottom CTA every step". 
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(24, 12, 24, bottomPadding + 12),
            child: GestureDetector(
              onTap: _nextStep,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.redGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: AppColors.redShadow,
                ),
                child: Center(
                  child: Text("Continue →", style: AppTextStyles.h3White),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
