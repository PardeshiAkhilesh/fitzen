import 'package:flutter/material.dart';

class OnboardingController extends ChangeNotifier {
  int currentIndex = 0;
  final int totalSteps = 11;
  final PageController pageController = PageController();

  // Selections
  String gender = 'Male';
  int age = 25;
  int heightCm = 170;
  double weightKg = 78.5;
  double targetWeightKg = 72.0;
  String activityLevel = 'Moderate';
  String goalType = 'Lose Weight';
  String weeklyRate = '0.5 kg';
  int dailyCalories = 2150;
  int proteinG = 150;
  int carbsG = 200;
  int fatG = 65;
  int waterGlasses = 8;
  
  bool isLoading = false;

  void nextStep(BuildContext context) async {
    if (currentIndex == 4) { // Post-activity api mock
      isLoading = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      isLoading = false;
      notifyListeners();
    }
    
    if (currentIndex < totalSteps - 1) {
      currentIndex++;
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      notifyListeners();
    } else {
      // Final submit
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  void previousStep() {
    if (currentIndex > 0) {
      currentIndex--;
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      notifyListeners();
    }
  }

  // Setters
  void setGender(String val) { gender = val; notifyListeners(); }
  void setActivity(String val) { activityLevel = val; notifyListeners(); }
  void setGoal(String val) { goalType = val; notifyListeners(); }
  void setRate(String val) { weeklyRate = val; notifyListeners(); }
}
