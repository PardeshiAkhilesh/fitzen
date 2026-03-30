import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/welcome_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/onboarding/onboarding_controller.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/weight/weight_screen.dart';
import 'features/goals/goals_screen.dart';
import 'features/profile/profile_screen.dart';
import 'core/widgets/bottom_nav_bar.dart';

void main() {
  runApp(const EliteFitApp());
}

class EliteFitApp extends StatelessWidget {
  const EliteFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elite FIT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.eliteFitTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/onboarding': (context) => const OnboardingController(),
        '/dashboard': (context) => const MainNavScreen(),
      },
    );
  }
}

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const WeightScreen(),
    const GoalsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
