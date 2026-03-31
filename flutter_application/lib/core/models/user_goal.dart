class UserGoal {
  final int dailyCalories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final String targetDate;
  final double targetWeight;
  final double weeklyGoalKg;
  final String goalType;
  final int targetBurnCalories;

  UserGoal({
    required this.dailyCalories, required this.proteinG, required this.carbsG,
    required this.fatG, required this.targetDate, required this.targetWeight,
    required this.weeklyGoalKg, required this.goalType, required this.targetBurnCalories,
  });

  factory UserGoal.fromJson(Map<String, dynamic> j) => UserGoal(
    dailyCalories: j['daily_calories'],
    proteinG: j['protein_g'],
    carbsG: j['carbs_g'],
    fatG: j['fat_g'],
    targetDate: j['target_date'],
    targetWeight: (j['target_weight'] as num).toDouble(),
    weeklyGoalKg: (j['weekly_goal_kg'] as num).toDouble(),
    goalType: j['goal_type'] ?? 'lose',
    targetBurnCalories: j['target_burn_calories'] ?? 0,
  );
}
