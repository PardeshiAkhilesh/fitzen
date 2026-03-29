import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/dark_input_field.dart';
import '../../core/widgets/orange_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // mock
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          // Header Image
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: AppImages.authBg,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(height: 240, color: const Color(0xBB000000)),
              Positioned(
                bottom: 24,
                left: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new, color: AppColors.orange),
                    ),
                    const SizedBox(height: 16),
                    Text("Welcome Back 👋", style: AppTextStyles.h1),
                    Text("Log in to continue your journey", style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  DarkInputField(
                    label: "EMAIL ADDRESS",
                    hint: "Enter your email",
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  DarkInputField(
                    label: "PASSWORD",
                    hint: "Enter password",
                    prefixIcon: Icons.lock,
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password?",
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 32),
                  OrangeButton(
                    text: _isLoading ? "Loading..." : "Login →",
                    onPressed: _isLoading ? () {} : _handleLogin,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF3A3A3A)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.g_mobiledata, color: Colors.white, size: 32),
                        const SizedBox(width: 8),
                        Text("Continue with Google", style: AppTextStyles.body),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Text(
                      "Don't have an account? Sign up",
                      style: AppTextStyles.body.copyWith(color: AppColors.orangeLight),
                    ),
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
