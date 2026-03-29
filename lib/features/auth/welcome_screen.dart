import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/orange_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // TOP 65% Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.65,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: AppImages.welcomeBg,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xFF0A0A0A)],
                      stops: [0.4, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Overlaid Top Left Logo
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 24,
            child: Row(
              children: [
                const Icon(Icons.local_fire_department, color: AppColors.orange, size: 32),
                const SizedBox(width: 8),
                Text(
                  "MacroMind",
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          
          // Overlaid Bottom Left of Image
          Positioned(
            top: screenHeight * 0.65 - 140, // rough position before gradient finish
            left: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("YOUR BEST", style: AppTextStyles.display),
                Text("SELF STARTS", style: AppTextStyles.display),
                Text("HERE", style: AppTextStyles.display),
              ],
            ),
          ),

          // BOTTOM 35% Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.35,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.scaffoldBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
              child: Column(
                children: [
                  Text(
                    "AI-powered fitness tracking that adapts to you",
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  OrangeButton(
                    text: "Get Started →",
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                  ),
                  const SizedBox(height: 12),
                  OrangeButton(
                    text: "I Already Have an Account",
                    isTransparent: true,
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                  const Spacer(),
                  Text(
                    "🔒 Your data is private and secure",
                    style: AppTextStyles.caption.copyWith(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
