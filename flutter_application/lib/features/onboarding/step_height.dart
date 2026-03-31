import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StepHeight extends StatefulWidget {
  final VoidCallback onNext;
  final ValueChanged<double> onHeightChanged;
  const StepHeight({super.key, required this.onNext, required this.onHeightChanged});

  @override
  State<StepHeight> createState() => _StepHeightState();
}

class _StepHeightState extends State<StepHeight> {
  double _height = 170;

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
              Text("Your height?", style: AppTextStyles.h1),
              Text("In centimeters", style: AppTextStyles.caption),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hero display
              Container(
                width: 250,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  boxShadow: AppColors.redShadow, // Active glow
                ),
                child: Column(
                  children: [
                    Text(_height.toInt().toString(), style: AppTextStyles.display.copyWith(fontSize: 80)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(height: 2, width: 30, color: AppColors.red),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text("cm", style: AppTextStyles.body),
                        ),
                        Container(height: 2, width: 30, color: AppColors.red),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              // Slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.red,
                    inactiveTrackColor: AppColors.inputBg,
                    thumbColor: AppColors.red,
                    overlayColor: AppColors.redGlow,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                  ),
                  child: Slider(
                    value: _height,
                    min: 100,
                    max: 250,
                    onChanged: (val) {
                      setState(() => _height = val);
                      widget.onHeightChanged(val);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
