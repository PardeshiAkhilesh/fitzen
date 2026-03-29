import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/hero_image_card.dart';
import '../../core/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HeroImageCard(
              imageUrl: AppImages.trainerHero,
              height: 260,
              borderRadius: 0,
              overlay: AppColors.imageOverlay,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.orange, width: 3),
                      boxShadow: [BoxShadow(color: AppColors.orange.withOpacity(0.2), blurRadius: 20, spreadRadius: 4)],
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.orange,
                      child: Text("JD", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text("James Doe", style: AppTextStyles.h2),
                  Text("james@email.com", style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.2),
                      border: Border.all(color: AppColors.orange),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: AppColors.orange, size: 14),
                        const SizedBox(width: 4),
                        Text("Fitness Freak", style: AppTextStyles.labelOrange),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    Expanded(child: _statBlock("Age", "25")),
                    const SizedBox(width: 12),
                    Expanded(child: _statBlock("Height", "170 cm")),
                    const SizedBox(width: 12),
                    Expanded(child: _statBlock("Weight", "78.5 kg")),
                  ],
                ),
                const SizedBox(height: 32),
                
                _settingsTile(Icons.person_outline, "Edit Profile"),
                _settingsTile(Icons.notifications_outlined, "Notifications"),
                _settingsTile(Icons.security, "Privacy & Security"),
                _settingsTile(Icons.help_outline, "Help & Support"),
                
                const SizedBox(height: 24),
                
                InkWell(
                  onTap: () async {
                    await context.read<AuthService>().logout();
                    Navigator.pushReplacementNamed(context, '/welcome');
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      border: Border.all(color: Colors.redAccent),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text("Logout", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBlock(String label, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(val, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: AppColors.orange.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.orange, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: AppTextStyles.body)),
          const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
        ],
      ),
    );
  }
}
