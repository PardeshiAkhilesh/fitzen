class DailyNutrition {
  final DateTime date;
  final double consumedCalories;
  final double consumedProtein;
  final double consumedCarbs;
  final double consumedFat;
  final double burnedCalories;
  final double remainingCalories;
  final double remainingProtein;
  final double remainingCarbs;
  final double remainingFat;

  DailyNutrition({
    required this.date, required this.consumedCalories, required this.consumedProtein,
    required this.consumedCarbs, required this.consumedFat, required this.burnedCalories,
    required this.remainingCalories, required this.remainingProtein,
    required this.remainingCarbs, required this.remainingFat,
  });

  factory DailyNutrition.fromJson(Map<String, dynamic> j) => DailyNutrition(
    date: _toDate(j['date']),
    consumedCalories: _toDouble(j['consumed_calories']),
    consumedProtein: _toDouble(j['consumed_protein']),
    consumedCarbs: _toDouble(j['consumed_carbs']),
    consumedFat: _toDouble(j['consumed_fat']),
    burnedCalories: _toDouble(j['burned_calories']),
    remainingCalories: _toDouble(j['remaining_calories']),
    remainingProtein: _toDouble(j['remaining_protein']),
    remainingCarbs: _toDouble(j['remaining_carbs']),
    remainingFat: _toDouble(j['remaining_fat']),
  );

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    if (v is String) {
      final parsed = double.tryParse(v);
      return parsed ?? 0.0;
    }
    return 0.0;
  }

  static DateTime _toDate(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is DateTime) return v;
    if (v is String) {
      // Accept ISO date or date-only formats like YYYY-MM-DD
      final parsed = DateTime.tryParse(v);
      if (parsed != null) return parsed;
      try {
        final parts = v.split('-');
        if (parts.length >= 3) {
          final y = int.tryParse(parts[0]) ?? DateTime.now().year;
          final m = int.tryParse(parts[1]) ?? DateTime.now().month;
          final d = int.tryParse(parts[2]) ?? DateTime.now().day;
          return DateTime(y, m, d);
        }
      } catch (_) {}
    }
    return DateTime.now();
  }
}
