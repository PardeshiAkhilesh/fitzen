import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_colors.dart';
import 'core/services/storage_service.dart';
import 'core/services/auth_service.dart';
import 'core/widgets/bottom_nav_bar.dart';

import 'features/splash/splash_screen.dart';
import 'features/auth/welcome_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/weight/weight_screen.dart';
import 'features/goals/goals_screen.dart';
import 'features/profile/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>(create: (_) => StorageService()),
        ChangeNotifierProxyProvider<StorageService, AuthService>(
          create: (ctx) => AuthService(ctx.read<StorageService>()),
          update: (ctx, storage, auth) => auth ?? AuthService(storage),
        ),
      ],
      child: const MacroMindApp(),
    ),
  );
}

class MacroMindApp extends StatelessWidget {
  const MacroMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MacroMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.scaffoldBg,
        brightness: Brightness.dark,
        primaryColor: AppColors.orange,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.orange,
          secondary: AppColors.orangeLight,
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (ctx) => const SplashScreen(),
        '/welcome': (ctx) => const WelcomeScreen(),
        '/login': (ctx) => const LoginScreen(),
        '/register': (ctx) => const RegisterScreen(),
        '/onboarding': (ctx) => const OnboardingScreen(),
        '/dashboard': (ctx) => const MainLayout(), // Hosts Bottom Nav
      },
    );
  }
}

// Master Layout for Bottom Nav
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
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
      backgroundColor: AppColors.scaffoldBg,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
