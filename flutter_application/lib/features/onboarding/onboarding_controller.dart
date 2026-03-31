import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/api_constants.dart';

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

  String _gender = 'male';
  int _age = 25;
  double _heightCm = 170.0;
  double _weightKg = 70.0;
  String _activityLevel = 'moderate';
  String _goalType = 'lose';
  double _targetWeightKg = 65.0;
  double _weeklyGoalKg = 0.5;
  int _targetCalories = 1800;
  int _proteinG = 135;
  int _carbsG = 180;
  int _fatG = 60;
  double _targetLiters = 2.0;
  bool _isSubmitting = false;

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _handleOnboardingComplete();
    }
  }

  Future<void> _handleOnboardingComplete() async {
    setState(() => _isSubmitting = true);

    try {
      await ApiService.post(ApiConstants.profileSetup, {
        'age': _age,
        'height_cm': _heightCm,
        'weight_kg': _weightKg,
        'gender': _gender,
        'activity_level': _activityLevel,
      });

      await ApiService.post(ApiConstants.goalsSet, {
        'target_weight': _targetWeightKg,
        'weekly_goal_kg': _weeklyGoalKg,
        'target_calories': _targetCalories,
        'goal_type': _goalType,
        'protein_g': _proteinG,
        'carbs_g': _carbsG,
        'fat_g': _fatG,
        'target_burn_calories': 0,
      });

      await ApiService.post(ApiConstants.waterGoal, {
        'target_liters': _targetLiters,
      });

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
      }
    } on DioException catch (e) {
      final detail = e.response?.data?['detail'] ?? 'Setup failed';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(detail.toString()), backgroundColor: const Color(0xFFE8191B)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection error during setup')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
                StepGender(onNext: _nextStep, onGenderChanged: (g) => setState(() => _gender = g)),
                StepAge(onNext: _nextStep, onAgeChanged: (a) => setState(() => _age = a)),
                StepHeight(onNext: _nextStep, onHeightChanged: (h) => setState(() => _heightCm = h)),
                StepWeight(onNext: _nextStep, onWeightChanged: (w) => setState(() => _weightKg = w)),
                StepActivity(onNext: _nextStep, onActivityChanged: (a) => setState(() => _activityLevel = a)),
                StepGoalType(onNext: _nextStep, onGoalTypeChanged: (g) => setState(() => _goalType = g)),
                StepTargetWeight(onNext: _nextStep, onTargetWeightChanged: (tw) => setState(() => _targetWeightKg = tw)),
                StepWeeklyRate(onNext: _nextStep, onRateChanged: (r) => setState(() => _weeklyGoalKg = r)),
                StepCalories(onNext: _nextStep, onCaloriesChanged: (c) => setState(() => _targetCalories = c)),
                StepMacros(onNext: _nextStep, onMacrosChanged: (p, c, f) => setState(() { _proteinG = p; _carbsG = c; _fatG = f; })),
                StepWater(onNext: _nextStep, onWaterChanged: (w) => setState(() => _targetLiters = w)),
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
                  child: _isSubmitting
                      ? const SizedBox(height: 24, width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text("Continue →", style: AppTextStyles.h3White),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
