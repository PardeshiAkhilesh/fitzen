import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StepTargetWeight extends StatefulWidget {
  final VoidCallback onNext;
  final ValueChanged<double> onTargetWeightChanged;
  const StepTargetWeight({super.key, required this.onNext, required this.onTargetWeightChanged});

  @override
  State<StepTargetWeight> createState() => _StepTargetWeightState();
}

class _StepTargetWeightState extends State<StepTargetWeight> {
  double _targetWeight = 65.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          color: AppColors.white,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Target Weight?", style: AppTextStyles.h1),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text("Current: 70 kg", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  boxShadow: AppColors.redShadow,
                ),
                child: Column(
                  children: [
                    Text(_targetWeight.toStringAsFixed(1), style: AppTextStyles.display.copyWith(fontSize: 80)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(height: 2, width: 30, color: AppColors.red),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text("kg", style: AppTextStyles.body),
                        ),
                        Container(height: 2, width: 30, color: AppColors.red),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _circleControl(Icons.remove, () {
                    setState(() => _targetWeight -= 0.5);
                    widget.onTargetWeightChanged(_targetWeight);
                  }),
                  _circleControl(Icons.add, () {
                    setState(() => _targetWeight += 0.5);
                    widget.onTargetWeightChanged(_targetWeight);
                  }),
                ],
              ),
              const SizedBox(height: 40),
              // Difference indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x66E8191B)),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.trending_down, color: AppColors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text("5 kg to lose · ~10 weeks at 0.5 kg/week",
                            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleControl(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          gradient: AppColors.redGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.redGlow,
              blurRadius: 20,
              spreadRadius: 2,
            )
          ],
        ),
        child: Icon(icon, color: AppColors.white, size: 28),
      ),
    );
  }
}
