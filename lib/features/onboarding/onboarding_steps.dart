import 'package:flutter/material.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/hero_image_card.dart';
import 'onboarding_controller.dart';

// --- STEP 1: GENDER ---
class StepGender extends StatelessWidget {
  final OnboardingController c;
  const StepGender({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: HeroImageCard(
            key: ValueKey(c.gender),
            imageUrl: c.gender == 'Male' ? AppImages.onboardingMale : AppImages.onboardingFemale,
            height: 260,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("What's your", style: AppTextStyles.h2),
                Text("gender?", style: AppTextStyles.display),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              _GenderCard(c: c, label: 'Male', icon: '👨'),
              const SizedBox(height: 12),
              _GenderCard(c: c, label: 'Female', icon: '👩'),
            ],
          ),
        ),
      ],
    );
  }
}

class _GenderCard extends StatelessWidget {
  final OnboardingController c;
  final String label;
  final String icon;

  const _GenderCard({required this.c, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isSelected = c.gender == label;
    return GestureDetector(
      onTap: () => c.setGender(label),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orange.withOpacity(0.08) : AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.orange : AppColors.divider, width: isSelected ? 1.5 : 1.0),
        ),
        child: Row(
          children: [
            Container(width: 4, decoration: BoxDecoration(color: isSelected ? AppColors.orange : Colors.transparent, borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)))),
            const SizedBox(width: 16),
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: AppTextStyles.h3)),
            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? AppColors.orange : AppColors.divider, size: 24),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}

// --- STEP 2: AGE ---
class StepAge extends StatelessWidget {
  final OnboardingController c;
  const StepAge({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(AppImages.authBg, "How old are you?", "Helps personalise your plan"),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(height: 72, decoration: const BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: AppColors.orange, width: 1)))),
              ListWheelScrollView.useDelegate(
                itemExtent: 72,
                perspective: 0.005,
                diameterRatio: 2.0,
                physics: const FixedExtentScrollPhysics(),
                overAndUnderCenterOpacity: 0.3,
                onSelectedItemChanged: (index) => c.age = index + 13,
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) => Center(child: Text("${index + 13}", style: AppTextStyles.display.copyWith(fontSize: 48))),
                  childCount: 88, // 13-100
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- STEP 3: HEIGHT ---
class StepHeight extends StatelessWidget {
  final OnboardingController c;
  const StepHeight({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(AppImages.authBg, "What's your height?", "In centimeters"),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(boxShadow: [BoxShadow(color: AppColors.orange.withOpacity(0.15), spreadRadius: 10, blurRadius: 40)]),
                  child: Column(
                    children: [
                      Text("${c.heightCm}", style: AppTextStyles.display.copyWith(fontSize: 72)),
                      Text("── cm ──", style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Slider(
                  value: c.heightCm.toDouble(),
                  min: 100, max: 250,
                  activeColor: AppColors.orange,
                  inactiveColor: AppColors.cardBg,
                  onChanged: (val) { c.heightCm = val.toInt(); c.notifyListeners(); },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// --- STEP 4: WEIGHT ---
class StepWeight extends StatelessWidget {
  final OnboardingController c;
  const StepWeight({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(AppImages.authBg, "Current weight?", "kg"),
        Expanded(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircleBtn(Icons.remove, () { c.weightKg -= 0.5; c.notifyListeners(); }),
                const SizedBox(width: 24),
                Text("${c.weightKg.toStringAsFixed(1)} kg", style: AppTextStyles.display),
                const SizedBox(width: 24),
                _buildCircleBtn(Icons.add, () { c.weightKg += 0.5; c.notifyListeners(); }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 64, height: 64,
        decoration: const BoxDecoration(gradient: AppColors.orangeGradient, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}

// --- STEP 5: ACTIVITY ---
class StepActivity extends StatelessWidget {
  final OnboardingController c;
  const StepActivity({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeroImageCard(
          imageUrl: AppImages.activityRunner, height: 200,
          content: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("How active are you?", style: AppTextStyles.h1),
            Text("Be honest — this shapes your daily targets", style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          ]),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _ActivityCard(c: c, label: 'Sedentary', sub: 'Little to no exercise', icon: '🛋️'),
              _ActivityCard(c: c, label: 'Light', sub: '1–3 days/week', icon: '🚶'),
              _ActivityCard(c: c, label: 'Moderate', sub: '3–5 days/week', icon: '🏃'),
              _ActivityCard(c: c, label: 'Active', sub: '6–7 days/week', icon: '💪'),
              _ActivityCard(c: c, label: 'Very Active', sub: 'Daily intense + physical job', icon: '🔥'),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final OnboardingController c;
  final String label, sub, icon;
  const _ActivityCard({required this.c, required this.label, required this.sub, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isSelected = c.activityLevel == label;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => c.setActivity(label),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.orange.withOpacity(0.08) : AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? AppColors.orange : AppColors.divider),
          ),
          child: Row(
            children: [
              if (isSelected) Container(width: 4, height: 40, color: AppColors.orange, margin: const EdgeInsets.only(right: 12)),
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                Text(sub, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ])),
            ],
          ),
        ),
      ),
    );
  }
}

// --- HELPER HEADER ---
Widget _buildHeader(String url, String title, String sub) {
  return HeroImageCard(
    imageUrl: url, height: 120,
    content: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: AppTextStyles.h1),
      Text(sub, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
    ]),
  );
}

// (Remaining steps implementation follows standard pattern)
class StepGoalType extends StatelessWidget {
  final OnboardingController c;
  const StepGoalType({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeroImageCard(imageUrl: AppImages.fullBodyWorkout, height: 220, content: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("What's your goal?", style: AppTextStyles.h1),
          Text("We'll customise everything around this", style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
        ])),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _GoalCard(c: c, label: 'Lose Weight', sub: 'Burn fat, slim down', icon: '🔻', img: AppImages.weightGoal),
              _GoalCard(c: c, label: 'Maintain Weight', sub: 'Stay at peak performance', icon: '➡️', img: AppImages.activityRunner),
              _GoalCard(c: c, label: 'Gain Muscle', sub: 'Build mass, maximize gains', icon: '🔺', img: AppImages.hardTraining),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final OnboardingController c;
  final String label, sub, icon, img;
  const _GoalCard({required this.c, required this.label, required this.sub, required this.icon, required this.img});

  @override
  Widget build(BuildContext context) {
    final isSelected = c.goalType == label;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => c.setGoal(label),
        child: Container(
          height: 130,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.orange.withOpacity(0.12) : AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? AppColors.orange : AppColors.divider, width: isSelected ? 2 : 1),
          ),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(label, style: AppTextStyles.h2),
                Text(sub, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ])),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(img, width: 60, height: 60, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepTargetWeight extends StatelessWidget {
  final OnboardingController c;
  const StepTargetWeight({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(AppImages.authBg, "Target weight?", "Current: ${c.weightKg} kg"),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(onTap: () { c.targetWeightKg -= 0.5; c.notifyListeners(); }, child: Container(width: 64, height: 64, decoration: const BoxDecoration(color: AppColors.cardBg, shape: BoxShape.circle), child: const Icon(Icons.remove, color: Colors.white, size: 32))),
              const SizedBox(width: 24),
              Text("${c.targetWeightKg.toStringAsFixed(1)} kg", style: AppTextStyles.display),
              const SizedBox(width: 24),
              InkWell(onTap: () { c.targetWeightKg += 0.5; c.notifyListeners(); }, child: Container(width: 64, height: 64, decoration: const BoxDecoration(color: AppColors.cardBg, shape: BoxShape.circle), child: const Icon(Icons.add, color: Colors.white, size: 32))),
            ],
          ),
        ),
        if (c.targetWeightKg != c.weightKg)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.orange.withOpacity(0.3))),
              child: Row(
                children: [
                  Icon(c.targetWeightKg < c.weightKg ? Icons.trending_down : Icons.trending_up, color: AppColors.orange),
                  const SizedBox(width: 8),
                  Text("${(c.targetWeightKg - c.weightKg).abs().toStringAsFixed(1)} kg diff", style: AppTextStyles.body),
                ],
              ),
            ),
          )
      ],
    );
  }
}

class StepWeeklyRate extends StatelessWidget {
  final OnboardingController c;
  const StepWeeklyRate({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    final rates = ['0.25 kg', '0.5 kg', '0.75 kg', '1.0 kg'];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text("Select Weekly Goal Rate", style: AppTextStyles.h2),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 2.5,
            children: rates.map((r) => GestureDetector(
              onTap: () => c.setRate(r),
              child: Container(
                decoration: BoxDecoration(
                  color: c.weeklyRate == r ? AppColors.orange : AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                alignment: Alignment.center,
                child: Text(r == '0.5 kg' ? '⭐ $r' : r, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
              ),
            )).toList(),
          )
        ],
      ),
    );
  }
}

class StepCalories extends StatelessWidget {
  final OnboardingController c;
  const StepCalories({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(20)),
          child: Text("✨ AI Recommended", style: AppTextStyles.labelOrange.copyWith(color: Colors.white)),
        ),
        const SizedBox(height: 60),
        Text("${c.dailyCalories}", style: AppTextStyles.display.copyWith(fontSize: 72, shadows: [Shadow(color: AppColors.orange.withOpacity(0.5), blurRadius: 20)])),
        Text("kcal / day", style: AppTextStyles.h3.copyWith(color: AppColors.orange)),
        const SizedBox(height: 60),
        Slider(
          value: c.dailyCalories.toDouble(), min: 1000, max: 4000, activeColor: AppColors.orange,
          onChanged: (val) { c.dailyCalories = val.toInt(); c.notifyListeners(); },
        ),
      ],
    );
  }
}

class StepMacros extends StatelessWidget {
  final OnboardingController c;
  const StepMacros({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text("Set your macros", style: AppTextStyles.h1),
        Text("Daily nutrition breakdown", style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 24),
        _MacroRow("Protein", c.proteinG, AppColors.protein, c.dailyCalories, (val) { c.proteinG = val; c.notifyListeners(); }),
        const SizedBox(height: 16),
        _MacroRow("Carbs", c.carbsG, AppColors.carbs, c.dailyCalories, (val) { c.carbsG = val; c.notifyListeners(); }),
        const SizedBox(height: 16),
        _MacroRow("Fat", c.fatG, AppColors.fat, c.dailyCalories, (val) { c.fatG = val; c.notifyListeners(); }),
      ],
    );
  }
}

class _MacroRow extends StatelessWidget {
  final String label;
  final int grams;
  final Color color;
  final int maxCals;
  final Function(int) onChanged;
  const _MacroRow(this.label, this.grams, this.color, this.maxCals, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: AppTextStyles.h3)),
              Row(
                children: [
                  GestureDetector(onTap: () => onChanged(grams - 5), child: const Icon(Icons.remove_circle, color: AppColors.textSecondary)),
                  const SizedBox(width: 12),
                  Text("${grams}g", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  GestureDetector(onTap: () => onChanged(grams + 5), child: const Icon(Icons.add_circle, color: AppColors.textSecondary)),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: grams / 300, color: color, backgroundColor: AppColors.scaffoldBg, minHeight: 6),
        ],
      ),
    );
  }
}

class StepWater extends StatelessWidget {
  final OnboardingController c;
  const StepWater({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("💧 ${c.waterGlasses}", style: AppTextStyles.display.copyWith(fontSize: 72)),
        Text("glasses = ${(c.waterGlasses * 0.25).toStringAsFixed(1)} liters", style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 48),
        Slider(
          value: c.waterGlasses.toDouble(), min: 1, max: 20, activeColor: Colors.blue,
          onChanged: (val) { c.waterGlasses = val.toInt(); c.notifyListeners(); },
        ),
      ],
    );
  }
}
