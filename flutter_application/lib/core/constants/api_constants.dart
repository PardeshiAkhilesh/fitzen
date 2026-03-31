import 'package:flutter/foundation.dart';

class ApiConstants {
  static const String _configuredBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  static String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) {
      return _configuredBaseUrl;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }

    return 'http://127.0.0.1:8000';
  }
  
  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // Profile / Onboarding
  static const String profileSetup = '/profile/setup';
  static const String profileMe = '/profile/me';

  // Goals
  static const String goalsSet = '/goals/set';
  static const String goalsMe = '/goals/me';

  // Weight
  static const String weightLog = '/weight/log';
  static const String weightHistory = '/weight/history';
  static const String weightSummary = '/weight/summary';

  // Water
  static const String waterGoal = '/water/goal';
  static const String waterAddGlass = '/water/add-glass';
  static const String waterToday = '/water/today';

  // Dashboard
  static const String llmLog = '/llm/log';
  static const String foodOrWorkoutToday = '/food-or-workout/today';
  static const String foodOrWorkoutLogsToday = '/food-or-workout/logs/today';
  static const String workoutPlan = '/workout-plan';
  static const String workoutPlanCalculateBurn = '/workout-plan/calculate-burn';
  static const String speechToText = '/api/speech-to-text/';
}
