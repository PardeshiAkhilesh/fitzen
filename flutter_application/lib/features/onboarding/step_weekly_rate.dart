import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StepWeeklyRate extends StatefulWidget {
  final VoidCallback onNext;
  const StepWeeklyRate({super.key, required this.onNext});

  @override
  State<StepWeeklyRate> createState() => _StepWeeklyRateState();
}

class _StepWeeklyRateState extends State<StepWeeklyRate> {
  int _selectedRate = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Text("Weekly Rate", style: AppTextStyles.h1, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text("How fast do you want to reach your goal?", 
            style: AppTextStyles.caption, textAlign: TextAlign.center),
          const SizedBox(height: 40),
          
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildChip(0, "0.25 kg\nper week"),
                _buildChip(1, "⭐ 0.5 kg\nper week", isRecommended: true),
                _buildChip(2, "0.75 kg\nper week"),
                _buildChip(3, "1.0 kg\nper week"),
              ],
            ),
          ),
          
          // Animated info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color.fromRGBO(232, 25, 27, 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow("📅", "Estimated goal date:", "June 15, 2025"),
                const SizedBox(height: 12),
                _infoRow("🔴", "Daily calorie adjustment:", "-550 kcal/day"),
                const SizedBox(height: 12),
                _infoRow("⏱️", "Time to goal:", "10 weeks"),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _infoRow(String emoji, String label, String value) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.medGray)),
        const Spacer(),
        Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.black)),
      ],
    );
  }

  Widget _buildChip(int index, String text, {bool isRecommended = false}) {
    final isSelected = _selectedRate == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedRate = index),
      child: Container(
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.redGradient : null,
          color: isSelected ? null : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? null : Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: isSelected ? AppColors.redShadow : [],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: isSelected
                  ? AppTextStyles.bodyWhiteBold
                  : AppTextStyles.body.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
            ),
            if (isRecommended)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.white : AppColors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Recommended",
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.red : AppColors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
