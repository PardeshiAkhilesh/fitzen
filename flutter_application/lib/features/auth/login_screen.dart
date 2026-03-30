import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/elite_input_field.dart';
import '../../core/widgets/red_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    // Mock login API call
    Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Header Image
          SizedBox(
            height: 240,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: AppImages.authBg,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(height: 240, color: const Color(0xCC000000)),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 4, color: AppColors.red),
                ),
                Positioned(
                  bottom: 24,
                  left: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 18),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text("Welcome Back 👋", style: AppTextStyles.h1White),
                      Text("Sign in to continue your journey", style: AppTextStyles.captionWhite70),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Form Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  EliteInputField(
                    hintText: 'email@example.com',
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.red, size: 20),
                  ),
                  const SizedBox(height: 16),
                  EliteInputField(
                    hintText: '••••••••',
                    labelText: 'Password',
                    obscureText: true,
                    controller: _passwordController,
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.red, size: 20),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("Forgot Password?", style: AppTextStyles.labelRed),
                  ),
                  const SizedBox(height: 32),
                  
                  RedButton(
                    text: 'Login',
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 16),
                  
                  OutlinedButton.icon(
                    // We don't have the SVG file right now, use icon
                    icon: const Icon(Icons.g_mobiledata, color: AppColors.black, size: 24),
                    label: Text("Continue with Google", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.black)),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: AppTextStyles.body),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, '/register'),
                        child: Text("Create one", style: AppTextStyles.labelRed),
                      ),
                    ],
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
