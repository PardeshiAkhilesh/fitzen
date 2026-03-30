import 'package:flutter/material.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/hero_image_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 30),
        children: [
          HeroImageCard(
            imageUrl: AppImages.authBg,
            height: 260,
            borderRadius: 0,
            overlay: AppColors.imageOverlayDark,
            content: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.red, width: 3),
                      boxShadow: const [
                        BoxShadow(color: Color(0x55E8191B), blurRadius: 20, spreadRadius: 4),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.red,
                      child: Text("JD", style: AppTextStyles.h2White),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("James Doe", style: AppTextStyles.h2White),
                  Text("james@email.com", style: AppTextStyles.captionWhite70),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text("Elite Fit Member", style: AppTextStyles.labelWhite),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _buildStatCard("Age", "26")),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard("Height", "170 cm")),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard("Weight", "78.5 kg")),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                children: [
                  _buildSettingRow(Icons.person_outline, "Edit Profile"),
                  const Divider(height: 1),
                  _buildSettingRow(Icons.flag_outlined, "My Goals"),
                  const Divider(height: 1),
                  _buildSettingRow(Icons.monitor_weight_outlined, "Weight History"),
                  const Divider(height: 1),
                  _buildSettingRow(Icons.notifications_outlined, "Notifications"),
                  const Divider(height: 1),
                  _buildSettingRow(Icons.info_outline, "About Elite Fit"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.red, width: 1.5),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Center(
                  child: Text("Log Out", style: AppTextStyles.labelRed),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.black)),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildSettingRow(IconData icon, String title) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.black)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF9A9A9A)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
