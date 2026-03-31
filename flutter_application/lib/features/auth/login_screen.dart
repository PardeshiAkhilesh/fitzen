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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    debugPrint('DEBUG LOGIN: Email=$email, Password length=${password.length}');

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      debugPrint('DEBUG LOGIN: Calling API ${ApiConstants.baseUrl}${ApiConstants.login}');
      final data = await ApiService.post(ApiConstants.login, {
        'email': email,
        'password': password,
      });

      debugPrint('DEBUG LOGIN: Response received: $data');
      await ApiService.saveToken(data['access_token']);
      debugPrint('DEBUG LOGIN: Token saved, navigating to dashboard');

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
      }
    } on DioException catch (e) {
      debugPrint('DEBUG LOGIN: DioException - ${e.response?.statusCode} - ${e.response?.data}');
      final detail = e.response?.data?['detail'] ?? 'Login failed';
      setState(() => _errorMessage = detail.toString());
    } catch (e) {
      debugPrint('DEBUG LOGIN: General error - $e');
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
                    text: 'Login',
                    onPressed: _handleLogin,
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
