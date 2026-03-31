class UserProfile {
  final int userId;
  final int age;
  final double heightCm;
  final double weightKg;
  final String gender;
  final String activityLevel;
  final int recommendedCalories;

  UserProfile({
    required this.userId, required this.age, required this.heightCm,
    required this.weightKg, required this.gender, required this.activityLevel,
    required this.recommendedCalories,
  });

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
    userId: j['user_id'],
    age: j['age'],
    heightCm: (j['height_cm'] as num).toDouble(),
    weightKg: (j['weight_kg'] as num).toDouble(),
    gender: j['gender'],
    activityLevel: j['activity_level'],
    recommendedCalories: j['recommended_calories'] ?? 0,
  );
}
