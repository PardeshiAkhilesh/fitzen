import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/dark_input_field.dart';
import '../../core/widgets/orange_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _handleRegister() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // mock
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/onboarding');
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
                    Text("Create Account", style: AppTextStyles.h1),
                    Text("Start your transformation today", style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
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
                    label: "FULL NAME",
                    hint: "Enter your name",
                    prefixIcon: Icons.person,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  DarkInputField(
                    label: "CONFIRM PASSWORD",
                    hint: "Re-enter password",
                    prefixIcon: Icons.lock,
                    isPassword: true,
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 32),
                  OrangeButton(
                    text: _isLoading ? "Loading..." : "Register →",
                    onPressed: _isLoading ? () {} : _handleRegister,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      "Already have an account? Login",
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
