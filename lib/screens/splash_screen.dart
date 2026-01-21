import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../config/app_constants.dart';
import '../services/auth_service.dart';
import 'onboarding_screen.dart';
import 'auth_screen.dart';
import 'home_screen.dart';

/// Splash screen - Entry point of the application
/// Displays branding and determines initial navigation route
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToNextScreen();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(AppConstants.splashDuration);

    if (!mounted) return;

    // Check if first launch
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch =
        prefs.getBool(AppConstants.PREF_IS_FIRST_LAUNCH) ?? true;

    // Check authentication status
    final authService = AuthService();
    final isLoggedIn = authService.isLoggedIn();

    // Determine navigation route
    Widget nextScreen;
    if (isFirstLaunch) {
      nextScreen = const OnboardingScreen();
      await prefs.setBool(AppConstants.PREF_IS_FIRST_LAUNCH, false);
    } else if (isLoggedIn) {
      nextScreen = const HomeScreen();
    } else {
      nextScreen = const AuthScreen();
    }

    // Navigate with smooth transition
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: AppConstants.animationDuration,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    _buildLogo(),
                    const SizedBox(height: 24),

                    // App Name
                    Text(
                      AppConstants.appName,
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tagline
                    Text(
                      AppConstants.appTagline,
                      style: AppTextStyles.subtitle1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Loading indicator
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradientLinear,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.restaurant_menu,
        size: 60,
        color: Colors.white,
      ),
    );
  }
}
