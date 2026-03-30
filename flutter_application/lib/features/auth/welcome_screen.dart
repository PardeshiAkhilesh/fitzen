import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/red_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: AppImages.welcomeBg,
                  height: screenHeight * 0.65,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
                Container(
                  height: screenHeight * 0.65,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x44000000), Color(0xFF000000)],
                      stops: [0.3, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  top: 56,
                  left: 24,
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text("EF", style: AppTextStyles.h3White),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "ELITE FIT",
                        style: AppTextStyles.h3White.copyWith(letterSpacing: 2),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 40 + (screenHeight * 0.35),
                  left: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("YOUR BEST", style: AppTextStyles.displayWhite.copyWith(height: 1.1, fontSize: 38)),
                      Text("SELF STARTS", style: AppTextStyles.displayWhite.copyWith(height: 1.1, fontSize: 38)),
                      Row(
                        children: [
                          Text("HERE ", style: AppTextStyles.displayWhite.copyWith(height: 1.1, fontSize: 38)),
                          Container(
                            height: 6,
                            width: 50,
                            color: AppColors.red,
                            margin: const EdgeInsets.only(bottom: 4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom White Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.40,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Best & Biggest Fitness Club 🏆",
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Certified Male & Female Coaches",
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  RedButton(
                    text: "Get Started →",
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.red, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: Text("I Already Have an Account", style: AppTextStyles.labelRed),
                  ),
                  const SizedBox(height: 20),
                  Text("📞 9028 100 303 · Katraj, Pune", style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
