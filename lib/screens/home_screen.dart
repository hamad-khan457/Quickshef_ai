import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../config/app_constants.dart';
import '../services/auth_service.dart';
import '../services/ai_service.dart';
import '../widgets/custom_button.dart';
import 'recipe_results_screen.dart';
import 'saved_recipes_screen.dart';
import 'profile_screen.dart';
import 'missing_ingredients_screen.dart';

/// Home screen - Main interaction point for ingredient input
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ingredientsController = TextEditingController();
  final AuthService _authService = AuthService();
  final AIService _aiService = AIService();

  bool _isGenerating = false;
  String _selectedTimeFilter = '15-30 min';
  int _currentNavIndex = 0;

  @override
  void dispose() {
    _ingredientsController.dispose();
    super.dispose();
  }

  Future<void> _generateRecipes() async {
    if (_ingredientsController.text.trim().isEmpty) {
      _showError(AppConstants.errorEmptyIngredients);
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final userId = _authService.currentUserId!;
      final recipes = await _aiService.generateRecipes(
        ingredients: _ingredientsController.text.trim(),
        userId: userId,
        timeFilter: _selectedTimeFilter,
        count: 3,
      );

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RecipeResultsScreen(
              recipes: recipes,
              ingredients: _ingredientsController.text.trim(),
            ),
          ),
        );
      }
    } catch (e) {
      _showError('Failed to generate recipes: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _currentNavIndex == 0
          ? _buildHomeContent()
          : _currentNavIndex == 1
              ? const SavedRecipesScreen()
              : _currentNavIndex == 2
                  ? const ProfileScreen()
                  : const MissingIngredientsScreen(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        _currentNavIndex == 0
            ? AppConstants.appName
            : _currentNavIndex == 1
                ? 'Saved Recipes'
                : _currentNavIndex == 2
                    ? 'Profile'
                    : 'Missing Ingredients',
        style: AppTextStyles.h4,
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.cardBackground,
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Greeting section
            _buildGreeting(),
            const SizedBox(height: 24),

            // AI suggestion chip
            _buildSuggestionChip(),
            const SizedBox(height: 32),

            // Ingredients input section
            _buildIngredientsInput(),
            const SizedBox(height: 16),

            // Time filter
            _buildTimeFilter(),
            const SizedBox(height: 24),

            // Generate button
            CustomButton(
              text: 'Generate Recipes 🍳',
              onPressed: _generateRecipes,
              isLoading: _isGenerating,
              icon: Icons.auto_awesome,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    final userName = _authService.currentUser?.displayName ?? 'Chef';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hi $userName! 👋",
          style: AppTextStyles.h3.copyWith(
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "What's in your kitchen today?",
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.accentOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accentOrange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb,
            color: AppColors.accentOrange,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Try quick 10-minute meals today!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.accentOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Ingredients',
          style: AppTextStyles.subtitle1.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.secondaryCream,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: AppColors.divider,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: _ingredientsController,
            maxLines: 5,
            style: AppTextStyles.bodyLarge,
            decoration: InputDecoration(
              hintText: 'E.g., chicken, rice, tomatoes, onions...',
              hintStyle: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textLight,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cooking Time',
          style: AppTextStyles.subtitle1.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AppConstants.timeFilters.map((time) {
            final isSelected = _selectedTimeFilter == time;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimeFilter = time;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.secondaryCream,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primaryGreen : AppColors.divider,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  time,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentNavIndex,
      onTap: (index) {
        setState(() {
          _currentNavIndex = index;
        });
      },
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Missing',
        ),
      ],
    );
  }
}
