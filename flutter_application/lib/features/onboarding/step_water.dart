import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/image_constants.dart';
import '../../core/widgets/hero_image_card.dart';

class StepWater extends StatefulWidget {
  final VoidCallback onNext;
  const StepWater({super.key, required this.onNext});

  @override
  State<StepWater> createState() => _StepWaterState();
}

class _StepWaterState extends State<StepWater> {
  int _glasses = 8;
  bool _isComplete = false;

  void _handleComplete() {
    setState(() => _isComplete = true);
    Future.delayed(const Duration(milliseconds: 1000), () {
      widget.onNext();
    });
  }

  @override
  Widget build(BuildContext context) {
    double liters = _glasses * 0.25;

    return Column(
      children: [
        HeroImageCard(
          imageUrl: AppImages.hydrationImg,
          height: 180,
          borderRadius: 0,
          overlay: AppColors.imageOverlayDark,
          content: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Stay Hydrated 💧", style: AppTextStyles.h1White),
                Text("How many glasses per day?", style: AppTextStyles.captionWhite),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isComplete)
                const Icon(Icons.check_circle, color: AppColors.red, size: 120)
              else ...[
                Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppColors.redShadow,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("💧", style: TextStyle(fontSize: 40)),
                          const SizedBox(width: 8),
                          Text(_glasses.toString(), style: AppTextStyles.display.copyWith(fontSize: 72)),
                        ],
                      ),
                      Text("glasses", style: AppTextStyles.body),
                      const SizedBox(height: 8),
                      Text("= ${liters.toStringAsFixed(1)} liters", style: AppTextStyles.labelRed),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 4,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(12, (index) {
                    bool isFilled = index < _glasses;
                    return Icon(
                      Icons.water_drop,
                      color: isFilled ? const Color(0xFF2979FF) : const Color(0xFFE0E0E0),
                      size: 26,
                    );
                  }),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.red,
                      inactiveTrackColor: AppColors.inputBg,
                      thumbColor: AppColors.red,
                      overlayColor: AppColors.redGlow,
                    ),
                    child: Slider(
                      value: _glasses.toDouble(),
                      min: 1,
                      max: 20,
                      divisions: 19,
                      onChanged: (val) => setState(() => _glasses = val.toInt()),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.red,
                    side: const BorderSide(color: AppColors.red, width: 2),
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text("Finish Setup"),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
