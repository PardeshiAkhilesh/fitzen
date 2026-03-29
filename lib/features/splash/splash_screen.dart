import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _showText = false;
  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    // Set fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    // 1. Logo
    _controller.forward();
    
    // 2. Title fade in
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() => _showText = true);
    }
    
    // 3. Loading bar
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _showLoader = true);
    }
    
    // Nav logic
    await Future.delayed(const Duration(milliseconds: 1600));
    if (mounted) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [Color(0x22E8691A), Color(0xFF0A0A0A)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: const Icon(
                    Icons.local_fire_department,
                    color: AppColors.orange,
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: _showText ? 1.0 : 0.0,
                child: Column(
                  children: [
                    Text("MacroMind", style: AppTextStyles.h1),
                    Text("Track. Train. Transform.", style: AppTextStyles.caption),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: _showLoader ? 1.0 : 0.0,
                child: SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    color: AppColors.orange,
                    backgroundColor: AppColors.cardBg,
                    minHeight: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
