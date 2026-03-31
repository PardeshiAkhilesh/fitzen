import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StepWeight extends StatefulWidget {
  final VoidCallback onNext;
  final ValueChanged<double> onWeightChanged;
  const StepWeight({super.key, required this.onNext, required this.onWeightChanged});

  @override
  State<StepWeight> createState() => _StepWeightState();
}

class _StepWeightState extends State<StepWeight> {
  double _weight = 70.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          color: AppColors.white,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Your weight?", style: AppTextStyles.h1),
              Text("In kilograms", style: AppTextStyles.caption),
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
                    Text(_weight.toStringAsFixed(1), style: AppTextStyles.display.copyWith(fontSize: 80)),
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
                    setState(() => _weight -= 0.5);
                    widget.onWeightChanged(_weight);
                  }),
                  _circleControl(Icons.add, () {
                    setState(() => _weight += 0.5);
                    widget.onWeightChanged(_weight);
                  }),
                ],
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
