import 'package:flutter/material.dart';
import '../models/shopping_item_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

/// Missing Ingredients Screen - Shows all missing ingredients from shopping list
class MissingIngredientsScreen extends StatefulWidget {
  const MissingIngredientsScreen({Key? key}) : super(key: key);

  @override
  State<MissingIngredientsScreen> createState() =>
      _MissingIngredientsScreenState();
}

class _MissingIngredientsScreenState extends State<MissingIngredientsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  // Track items being deleted with animation
  final Set<String> _deletingItems = {};

  Future<void> _deleteItem(String itemId) async {
    // Add to deleting set to start animation
    setState(() {
      _deletingItems.add(itemId);
    });

    // Wait for animation (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Delete from Firestore after animation
      await _firestoreService.deleteShoppingItem(itemId);

      // Remove from deleting set (UI will update via stream)
      if (mounted) {
        setState(() {
          _deletingItems.remove(itemId);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _deletingItems.remove(itemId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete item: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = _authService.currentUserId;

    if (userId == null) {
      return Scaffold(
        body: const Center(
          child: Text('Please log in to view your shopping list.'),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder<List<ShoppingItemModel>>(
        stream: _firestoreService.getShoppingListStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No missing ingredients yet',
                      style: AppTextStyles.h5.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add recipes to see missing ingredients here',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isDeleting = _deletingItems.contains(item.itemId);

              return AnimatedOpacity(
                opacity: isDeleting ? 0.5 : 1.0,
                duration: const Duration(milliseconds: 500),
                child: AnimatedSlide(
                  offset: isDeleting ? const Offset(1, 0) : Offset.zero,
                  duration: const Duration(milliseconds: 500),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        children: [
                          // Checkbox on the left
                          Checkbox(
                            value: isDeleting,
                            onChanged: isDeleting
                                ? null
                                : (value) {
                                    if (value == true && item.itemId != null) {
                                      _deleteItem(item.itemId!);
                                    }
                                  },
                            activeColor: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 12),
                          // Ingredient name
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.itemName,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    decoration: isDeleting
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: isDeleting
                                        ? AppColors.textLight
                                        : AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (item.quantity != '1')
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      item.quantity,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
