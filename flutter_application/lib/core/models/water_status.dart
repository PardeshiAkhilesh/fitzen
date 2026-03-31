class WaterStatus {
  final int targetGlasses;
  final int consumedGlasses;
  final int remainingGlasses;
  final double percentage;

  WaterStatus({required this.targetGlasses, required this.consumedGlasses,
      required this.remainingGlasses, required this.percentage});

  factory WaterStatus.fromJson(Map<String, dynamic> j) => WaterStatus(
    targetGlasses: j['target_glasses'] ?? 8,
    consumedGlasses: j['consumed_glasses'] ?? 0,
    remainingGlasses: j['remaining_glasses'] ?? 8,
    percentage: (j['percentage'] as num?)?.toDouble() ?? 0.0,
  );
}
