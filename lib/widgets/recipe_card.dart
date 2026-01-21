import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../config/app_constants.dart';

/// Recipe card widget for displaying recipe summaries
class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final bool showDeleteButton;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.onTap,
    this.onDelete,
    this.showDeleteButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      color: AppColors.cardBackground,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recipe Name
                        Text(
                          recipe.recipeName,
                          style: AppTextStyles.h5.copyWith(
                            color: AppColors.primaryGreen,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Category Badge
                        _buildCategoryBadge(),
                      ],
                    ),
                  ),
                  if (showDeleteButton && onDelete != null)
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                      ),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Recipe Details Row
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    icon: Icons.schedule,
                    label: recipe.prepTime,
                  ),
                  _buildInfoChip(
                    icon: Icons.local_fire_department,
                    label: '${recipe.calories} cal',
                  ),
                  _buildInfoChip(
                    icon: Icons.bar_chart,
                    label: recipe.difficulty,
                    color: _getDifficultyColor(recipe.difficulty),
                  ),
                ],
              ),

              // Missing Ingredients Warning
              if (recipe.missingIngredients.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildMissingIngredientsWarning(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accentOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        recipe.category,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.accentOrange,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: color ?? AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMissingIngredientsWarning() {
    final int count = recipe.missingIngredients.length;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 16,
            color: AppColors.warning,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$count missing ingredient${count > 1 ? 's' : ''}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}

/// Compact recipe card for grid layouts
class CompactRecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onTap;

  const CompactRecipeCard({
    Key? key,
    required this.recipe,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.recipeName,
                style: AppTextStyles.subtitle1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    recipe.prepTime,
                    style: AppTextStyles.caption,
                  ),
                  Text(
                    '${recipe.calories} cal',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
