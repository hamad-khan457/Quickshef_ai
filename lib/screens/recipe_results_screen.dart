import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/recipe_card.dart';
import 'recipe_details_screen.dart';

/// Recipe Results Screen - Displays AI-generated recipes
class RecipeResultsScreen extends StatelessWidget {
  final List<RecipeModel> recipes;
  final String ingredients;

  const RecipeResultsScreen({
    Key? key,
    required this.recipes,
    required this.ingredients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipe Suggestions',
          style: AppTextStyles.h4,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with ingredients
            _buildHeader(),

            // Recipes list
            Expanded(
              child: recipes.isEmpty
                  ? _buildEmptyState()
                  : _buildRecipesList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      color: AppColors.secondaryCream,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Based on your ingredients:',
            style: AppTextStyles.subtitle1.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ingredients,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 16,
                color: AppColors.accentOrange,
              ),
              const SizedBox(width: 8),
              Text(
                '${recipes.length} recipes generated',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.accentOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(24.0),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: RecipeCard(
            recipe: recipe,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RecipeDetailsScreen(
                    recipe: recipe,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 80,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 24),
            Text(
              'No Recipes Found',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try different ingredients or adjust your filters',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
