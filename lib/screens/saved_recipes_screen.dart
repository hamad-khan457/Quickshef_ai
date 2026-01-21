import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/recipe_card.dart';
import 'recipe_details_screen.dart';

/// Saved Recipes Screen - Display user's saved recipes
class SavedRecipesScreen extends StatefulWidget {
  const SavedRecipesScreen({Key? key}) : super(key: key);

  @override
  State<SavedRecipesScreen> createState() => _SavedRecipesScreenState();
}

class _SavedRecipesScreenState extends State<SavedRecipesScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();

  List<RecipeModel> _allRecipes = [];
  List<RecipeModel> _filteredRecipes = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = _authService.currentUserId;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // ✅ FIXED: Fetch recipes with error handling
      final recipes = await _firestoreService.getSavedRecipes(userId);

      if (mounted) {
        setState(() {
          _allRecipes = recipes;
          _filteredRecipes = recipes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });

        // Check if it's an index error
        if (e.toString().contains('index') ||
            e.toString().contains('Index') ||
            e.toString().contains('create_composite')) {
          _showIndexErrorDialog(e.toString());
        } else {
          _showError('Failed to load recipes: ${e.toString()}');
        }
      }
    }
  }

  void _showIndexErrorDialog(String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.warning),
            const SizedBox(width: 8),
            const Text('Firestore Index Required'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Firestore database needs an index to fetch recipes efficiently.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Steps to fix:',
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '1. Look for the URL in the error below\n'
                '2. Click/copy the URL\n'
                '3. It will open Firebase Console\n'
                '4. Click "Create Index"\n'
                '5. Wait 2-3 minutes\n'
                '6. Come back and click "Retry"',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.divider),
                ),
                child: SelectableText(
                  error,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _loadRecipes(); // Retry
            },
            child: const Text('Retry'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _searchRecipes(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredRecipes = _allRecipes.where((recipe) {
        return recipe.recipeName.toLowerCase().contains(_searchQuery) ||
            recipe.category.toLowerCase().contains(_searchQuery) ||
            recipe.ingredients
                .any((ing) => ing.toLowerCase().contains(_searchQuery));
      }).toList();
    });
  }

  Future<void> _deleteRecipe(RecipeModel recipe) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content:
            Text('Are you sure you want to delete "${recipe.recipeName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && recipe.recipeId != null) {
      try {
        await _firestoreService.deleteRecipe(recipe.recipeId!);
        await _loadRecipes();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recipe deleted successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        _showError('Failed to delete recipe: ${e.toString()}');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _loadRecipes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading your recipes...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchRecipes('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _searchRecipes,
            ),
          ),

          // Recipe count
          if (_filteredRecipes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_filteredRecipes.length} recipe${_filteredRecipes.length != 1 ? 's' : ''} found',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),

          // Recipes list
          Expanded(
            child: _filteredRecipes.isEmpty
                ? _buildEmptyState()
                : _buildRecipesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesList() {
    return RefreshIndicator(
      onRefresh: _loadRecipes,
      color: AppColors.primaryGreen,
      child: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: _filteredRecipes.length,
        itemBuilder: (context, index) {
          final recipe = _filteredRecipes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: RecipeCard(
              recipe: recipe,
              showDeleteButton: true,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsScreen(
                      recipe: recipe,
                    ),
                  ),
                );
              },
              onDelete: () => _deleteRecipe(recipe),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '📖',
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 24),
            Text(
              _searchQuery.isEmpty ? 'No Saved Recipes' : 'No Results Found',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isEmpty
                  ? 'Start saving recipes to see them here'
                  : 'Try a different search term',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadRecipes,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry Loading'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
