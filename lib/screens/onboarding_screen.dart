import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../config/app_constants.dart';
import '../widgets/custom_button.dart';
import 'auth_screen.dart';

/// Onboarding screen with 3 slides explaining app value
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.restaurant,
      title: 'Cook Smart',
      subtitle: 'Turn your ingredients into delicious meals',
      emoji: '🍳',
    ),
    OnboardingPage(
      icon: Icons.psychology,
      title: 'Powered by AI',
      subtitle: 'Get personalized recipes in seconds',
      emoji: '🤖',
    ),
    OnboardingPage(
      icon: Icons.shopping_basket,
      title: 'Save Time & Reduce Waste',
      subtitle: 'Use what you already have',
      emoji: '♻️',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToAuth() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.animationDuration,
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: CustomTextButton(
                  text: 'Skip',
                  onPressed: _navigateToAuth,
                ),
              ),
            ),

            // PageView - FIXED: Added Flexible wrapper
            Flexible(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Page indicators
            _buildPageIndicators(),
            const SizedBox(height: 24),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  CustomButton(
                    text: _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: _nextPage,
                  ),
                  if (_currentPage == _pages.length - 1) ...[
                    const SizedBox(height: 16),
                    CustomTextButton(
                      text: 'Already have an account? Sign In',
                      onPressed: _navigateToAuth,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          // Emoji illustration
          Text(
            page.emoji,
            style: const TextStyle(fontSize: 100),
          ),
          const SizedBox(height: 32),

          // Icon
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 35,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            page.title,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.primaryGreen,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Subtitle
          Text(
            page.subtitle,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => Container(
          width: _currentPage == index ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.primaryGreen
                : AppColors.divider,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

/// Model class for onboarding page data
class OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final String emoji;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.emoji,
  });
}
