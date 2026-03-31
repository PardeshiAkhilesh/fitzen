class WeightSummary {
  final double? startWeight;
  final double? currentWeight;
  final double? targetWeight;
  final double weeklyPaceKg;
  final double? kgRemaining;
  final int? daysRemaining;
  final String? estimatedDate;
  final List<Map<String, dynamic>> history;

  WeightSummary({
    this.startWeight, this.currentWeight, this.targetWeight,
    required this.weeklyPaceKg, this.kgRemaining, this.daysRemaining,
    this.estimatedDate, required this.history,
  });

  factory WeightSummary.fromJson(Map<String, dynamic> j) => WeightSummary(
    startWeight: (j['start_weight'] as num?)?.toDouble(),
    currentWeight: (j['current_weight'] as num?)?.toDouble(),
    targetWeight: (j['target_weight'] as num?)?.toDouble(),
    weeklyPaceKg: (j['weekly_pace_kg'] as num?)?.toDouble() ?? 0.5,
    kgRemaining: (j['kg_remaining'] as num?)?.toDouble(),
    daysRemaining: j['days_remaining'] as int?,
    estimatedDate: j['estimated_date'] as String?,
    history: List<Map<String, dynamic>>.from(j['history'] ?? []),
  );
}
