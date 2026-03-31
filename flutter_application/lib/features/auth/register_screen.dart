import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/elite_input_field.dart';
import '../../core/widgets/red_button.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/api_constants.dart';

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
  String? _errorMessage;

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    if (password != confirmPassword) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    if (password.length < 8) {
      setState(() => _errorMessage = 'Password must be at least 8 characters');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      final data = await ApiService.post(ApiConstants.register, {
        'full_name': name,
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      });

      await ApiService.saveToken(data['access_token']);

      if (mounted) {
        Navigator.pushNamed(context, '/onboarding');
      }
    } on DioException catch (e) {
      final detail = e.response?.data?['detail'] ?? 'Registration failed';
      setState(() => _errorMessage = detail.toString());
    } catch (e) {
      setState(() => _errorMessage = 'Connection error. Is the server running?');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                      Text("Create Account", style: AppTextStyles.h1White),
                      Text("Start your Elite journey today", style: AppTextStyles.captionWhite70),
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
                    hintText: 'John Doe',
                    labelText: 'Full Name',
                    controller: _nameController,
                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.red, size: 20),
                  ),
                  const SizedBox(height: 16),
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
                  EliteInputField(
                    hintText: '••••••••',
                    labelText: 'Confirm Password',
                    obscureText: true,
                    controller: _confirmPasswordController,
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.red, size: 20),
                  ),
                  const SizedBox(height: 32),
                  
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE8E8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(_errorMessage!, style: const TextStyle(color: Color(0xFFE8191B), fontSize: 13)),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  RedButton(
                    text: 'Create Account',
                    onPressed: _handleRegister,
                    isLoading: _isLoading,
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
                    onPressed: _handleRegister,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ", style: AppTextStyles.body),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                        child: Text("Login", style: AppTextStyles.labelRed),
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
