import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StepAge extends StatefulWidget {
  final VoidCallback onNext;
  final ValueChanged<int> onAgeChanged;
  const StepAge({super.key, required this.onNext, required this.onAgeChanged});

  @override
  State<StepAge> createState() => _StepAgeState();
}

class _StepAgeState extends State<StepAge> {
  int _selectedAge = 25;

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
              Text("How old are you?", style: AppTextStyles.h1),
              Text("In years", style: AppTextStyles.caption),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              ListWheelScrollView.useDelegate(
                itemExtent: 72,
                perspective: 0.005,
                physics: const FixedExtentScrollPhysics(),
                overAndUnderCenterOpacity: 0.25,
                onSelectedItemChanged: (index) {
                  final age = index + 13;
                  setState(() => _selectedAge = age);
                  widget.onAgeChanged(age);
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    final age = index + 13;
                    final isSelected = age == _selectedAge;
                    return Center(
                      child: Text(
                        age.toString(),
                        style: isSelected
                            ? AppTextStyles.display.copyWith(fontSize: 64)
                            : AppTextStyles.display.copyWith(fontSize: 40, color: AppColors.lightGray),
                      ),
                    );
                  },
                  childCount: 100 - 13 + 1,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: 2, color: AppColors.red, width: 200),
                  const SizedBox(height: 72),
                  Container(height: 2, color: AppColors.red, width: 200),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
