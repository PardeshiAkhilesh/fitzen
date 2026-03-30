import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StepMacros extends StatefulWidget {
  final VoidCallback onNext;
  const StepMacros({super.key, required this.onNext});

  @override
  State<StepMacros> createState() => _StepMacrosState();
}

class _StepMacrosState extends State<StepMacros> {
  int _protein = 150;
  int _carbs = 200;
  int _fat = 65;

  @override
  Widget build(BuildContext context) {
    int totalKcal = (_protein * 4) + (_carbs * 4) + (_fat * 9);
    int targetKcal = 2150;
    int diff = targetKcal - totalKcal;
    bool isBalanced = diff.abs() <= 50;

    return Column(
      children: [
        const SizedBox(height: 24),
        Text("Daily Macros", style: AppTextStyles.h1),
        const SizedBox(height: 24),
        
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              _buildMacroCard("Protein", AppColors.protein, _protein, "30", (val) => setState(() => _protein = val)),
              const SizedBox(height: 16),
              _buildMacroCard("Carbs", AppColors.carbs, _carbs, "45", (val) => setState(() => _carbs = val)),
              const SizedBox(height: 16),
              _buildMacroCard("Fat", AppColors.fat, _fat, "25", (val) => setState(() => _fat = val)),
            ],
          ),
        ),
        
        // Totals bar
        Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppColors.cardShadow,
            border: Border.all(color: isBalanced ? AppColors.success : AppColors.warning),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Total: $totalKcal kcal", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
              Container(margin: const EdgeInsets.symmetric(horizontal: 8), height: 16, width: 1, color: AppColors.divider),
              if (isBalanced)
                const Row(children: [Icon(Icons.check_circle, color: AppColors.success, size: 16), SizedBox(width: 4), Text("Balanced")])
              else
                Row(children: [const Icon(Icons.warning, color: AppColors.warning, size: 16), const SizedBox(width: 4), Text("${diff.abs()} kcal diff")]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMacroCard(String title, Color color, int value, String percent, Function(int) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.h3),
              const Spacer(),
              _circleControl(Icons.remove, () => onChanged(value - 5)),
              const SizedBox(width: 12),
              Text("${value}g", style: AppTextStyles.h2),
              const SizedBox(width: 12),
              _circleControl(Icons.add, () => onChanged(value + 5)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: double.parse(percent) / 100,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("$title · $percent% of calories", style: AppTextStyles.caption),
          ),
        ],
      ),
    );
  }

  Widget _circleControl(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: AppColors.red,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 16),
      ),
    );
  }
}
