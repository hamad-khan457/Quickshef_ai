import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../models/shopping_item_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../config/app_constants.dart';
import '../widgets/custom_button.dart';

/// Recipe Details Screen - Shows complete recipe information
class RecipeDetailsScreen extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeDetailsScreen({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  bool _isSaving = false;
  bool _isAddingToShoppingList = false;

  Future<void> _saveRecipe() async {
    setState(() => _isSaving = true);

    try {
      final userId = _authService.currentUserId!;
      final recipeToSave = widget.recipe.copyWith(userId: userId);

      await _firestoreService.saveRecipe(recipeToSave);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppConstants.successRecipeSaved),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save recipe: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _addToShoppingList() async {
    if (widget.recipe.missingIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No missing ingredients to add'),
          backgroundColor: AppColors.info,
        ),
      );
      return;
    }

    setState(() => _isAddingToShoppingList = true);

    try {
      final userId = _authService.currentUserId!;
      final items = widget.recipe.missingIngredients
          .map((ingredient) => ShoppingItemModel(
                userId: userId,
                itemName: ingredient,
                quantity: '1',
                addedAt: DateTime.now(),
              ))
          .toList();

      await _firestoreService.addMultipleShoppingItems(items);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${items.length} items to shopping list'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add items: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingToShoppingList = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipe Details',
          style: AppTextStyles.h4,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share feature coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header section
            _buildHeader(),

            // Quick stats
            _buildQuickStats(),

            // Ingredients section
            _buildIngredientsSection(),

            // Missing ingredients warning
            if (widget.recipe.missingIngredients.isNotEmpty)
              _buildMissingIngredientsSection(),

            // Instructions section
            _buildInstructionsSection(),

            // Nutrition section
            _buildNutritionSection(),

            // Action buttons
            _buildActionButtons(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradientLinear,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.recipe.recipeName,
            style: AppTextStyles.h2.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildHeaderChip(
                Icons.restaurant,
                widget.recipe.category,
              ),
              const SizedBox(width: 12),
              _buildHeaderChip(
                Icons.bar_chart,
                widget.recipe.difficulty,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.schedule,
            label: 'Prep Time',
            value: widget.recipe.prepTime,
          ),
          _buildStatDivider(),
          _buildStatItem(
            icon: Icons.local_fire_department,
            label: 'Calories',
            value: '${widget.recipe.calories}',
          ),
          _buildStatDivider(),
          _buildStatItem(
            icon: Icons.restaurant,
            label: 'Servings',
            value: '2-3',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.subtitle1.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.divider,
    );
  }

  Widget _buildIngredientsSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients 🥘',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          ...widget.recipe.ingredients.map((ingredient) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ingredient,
                      style: AppTextStyles.bodyLarge,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMissingIngredientsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shopping_cart,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Missing Ingredients',
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...widget.recipe.missingIngredients.map((ingredient) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.remove_circle_outline,
                    size: 18,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ingredient,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instructions 📝',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          ...widget.recipe.instructions.asMap().entries.map((entry) {
            final index = entry.key;
            final instruction = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      instruction,
                      style: AppTextStyles.bodyLarge,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildNutritionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.secondaryCream,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition Facts 💪',
            style: AppTextStyles.h5.copyWith(
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNutritionItem(
                'Calories',
                '${widget.recipe.calories}',
              ),
              _buildNutritionItem(
                'Protein',
                widget.recipe.protein,
              ),
              _buildNutritionItem(
                'Carbs',
                widget.recipe.carbs,
              ),
              _buildNutritionItem(
                'Fats',
                widget.recipe.fats,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h5.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: [
          CustomButton(
            text: 'Save Recipe',
            onPressed: _saveRecipe,
            isLoading: _isSaving,
            icon: Icons.bookmark,
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Add to Shopping List',
            onPressed: _addToShoppingList,
            isLoading: _isAddingToShoppingList,
            isOutlined: true,
            icon: Icons.shopping_cart,
          ),
        ],
      ),
    );
  }
}
