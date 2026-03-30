class ApiConstants {
  static const String baseUrl = 'http://localhost:8000';
  
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

  // Water
  static const String waterGoal = '/water/goal';
  static const String waterAddGlass = '/water/add-glass';
  static const String waterToday = '/water/today';

  // Dashboard
  static const String llmLog = '/llm/log';
  static const String foodOrWorkoutToday = '/food-or-workout/today';
  static const String foodOrWorkoutLogsToday = '/food-or-workout/logs/today';
  static const String speechToText = '/api/speech-to-text/';
}
