import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';
import '../models/user_model.dart';
import '../models/shopping_item_model.dart';
import '../config/app_constants.dart';

/// Firestore service handling all database operations
/// Manages recipes, shopping lists, and user data
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===== USER OPERATIONS =====

  /// Create or update user in Firestore
  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
  }) async {
    try {
      final userModel = UserModel(
        uid: uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.firestoreUsers)
          .doc(uid)
          .set(userModel.toFirestore());
    } catch (e) {
      throw 'Failed to create user: $e';
    }
  }

  /// Get user data from Firestore
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.firestoreUsers)
          .doc(uid)
          .get();

      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw 'Failed to fetch user: $e';
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? dietaryPreference,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (dietaryPreference != null)
        updateData['dietaryPreference'] = dietaryPreference;

      await _firestore
          .collection(AppConstants.firestoreUsers)
          .doc(uid)
          .update(updateData);
    } catch (e) {
      throw 'Failed to update user profile: $e';
    }
  }

  /// Delete user account and all associated data
  Future<void> deleteUser(String uid) async {
    try {
      // Delete all recipes
      final recipes = await _firestore
          .collection(AppConstants.firestoreSavedRecipes)
          .where('userId', isEqualTo: uid)
          .get();

      for (var doc in recipes.docs) {
        await doc.reference.delete();
      }

      // Delete all shopping list items
      final shoppingItems = await _firestore
          .collection(AppConstants.firestoreShoppingList)
          .where('userId', isEqualTo: uid)
          .get();

      for (var doc in shoppingItems.docs) {
        await doc.reference.delete();
      }

      // Delete user document
      await _firestore
          .collection(AppConstants.firestoreUsers)
          .doc(uid)
          .delete();
    } catch (e) {
      throw 'Failed to delete user: $e';
    }
  }

  // ===== RECIPE OPERATIONS =====

  /// Save recipe to Firestore
  Future<String> saveRecipe(RecipeModel recipe) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.firestoreSavedRecipes)
          .add(recipe.toFirestore());

      return docRef.id;
    } catch (e) {
      throw 'Failed to save recipe: $e';
    }
  }

  /// Get all saved recipes for a user
  /// Get all saved recipes for a user
  Future<List<RecipeModel>> getSavedRecipes(String userId) async {
    try {
      // ✅ FIXED: Simple query without orderBy to avoid index requirement
      final snapshot = await _firestore
          .collection(AppConstants.firestoreSavedRecipes)
          .where('userId', isEqualTo: userId)
          .get();

      // Get all recipes
      final recipes =
          snapshot.docs.map((doc) => RecipeModel.fromFirestore(doc)).toList();

      // Sort in memory by createdAt (newest first)
      recipes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return recipes;
    } catch (e) {
      throw 'Failed to fetch saved recipes: $e';
    }
  }

  /// Get single recipe by ID
  Future<RecipeModel?> getRecipe(String recipeId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.firestoreSavedRecipes)
          .doc(recipeId)
          .get();

      if (!doc.exists) return null;
      return RecipeModel.fromFirestore(doc);
    } catch (e) {
      throw 'Failed to fetch recipe: $e';
    }
  }

  /// Search recipes by name
  Future<List<RecipeModel>> searchRecipes({
    required String userId,
    required String searchQuery,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.firestoreSavedRecipes)
          .where('userId', isEqualTo: userId)
          .orderBy('recipeName')
          .startAt([searchQuery]).endAt(['${searchQuery}\uf8ff']).get();

      return snapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw 'Failed to search recipes: $e';
    }
  }

  /// Get recipes by category
  Future<List<RecipeModel>> getRecipesByCategory({
    required String userId,
    required String category,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.firestoreSavedRecipes)
          .where('userId', isEqualTo: userId)
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw 'Failed to fetch recipes by category: $e';
    }
  }

  /// Get recipes by difficulty
  Future<List<RecipeModel>> getRecipesByDifficulty({
    required String userId,
    required String difficulty,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.firestoreSavedRecipes)
          .where('userId', isEqualTo: userId)
          .where('difficulty', isEqualTo: difficulty)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw 'Failed to fetch recipes by difficulty: $e';
    }
  }

  /// Delete recipe
  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _firestore
          .collection(AppConstants.firestoreSavedRecipes)
          .doc(recipeId)
          .delete();
    } catch (e) {
      throw 'Failed to delete recipe: $e';
    }
  }

  /// Get total recipe count for user
  Future<int> getRecipeCount(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.firestoreSavedRecipes)
          .where('userId', isEqualTo: userId)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      throw 'Failed to get recipe count: $e';
    }
  }

  // ===== SHOPPING LIST OPERATIONS =====

  /// Add item to shopping list
  Future<String> addToShoppingList(ShoppingItemModel item) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.firestoreShoppingList)
          .add(item.toFirestore());

      return docRef.id;
    } catch (e) {
      throw 'Failed to add item to shopping list: $e';
    }
  }

  /// Get all shopping list items for user
  Future<List<ShoppingItemModel>> getShoppingList(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.firestoreShoppingList)
          .where('userId', isEqualTo: userId)
          .get();

      final items = snapshot.docs
          .map((doc) => ShoppingItemModel.fromFirestore(doc))
          .toList();

      // Sort in memory by addedAt (newest first)
      items.sort((a, b) => b.addedAt.compareTo(a.addedAt));

      return items;
    } catch (e) {
      throw 'Failed to fetch shopping list: $e';
    }
  }

  /// Get unpurchased items
  Future<List<ShoppingItemModel>> getUnpurchasedItems(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.firestoreShoppingList)
          .where('userId', isEqualTo: userId)
          .where('isPurchased', isEqualTo: false)
          .get();

      final items = snapshot.docs
          .map((doc) => ShoppingItemModel.fromFirestore(doc))
          .toList();

      // Sort in memory by addedAt (newest first)
      items.sort((a, b) => b.addedAt.compareTo(a.addedAt));

      return items;
    } catch (e) {
      throw 'Failed to fetch unpurchased items: $e';
    }
  }

  /// Stream shopping list items for real-time updates
  Stream<List<ShoppingItemModel>> getShoppingListStream(String userId) {
    return _firestore
        .collection(AppConstants.firestoreShoppingList)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final items = snapshot.docs
          .map((doc) => ShoppingItemModel.fromFirestore(doc))
          .toList();
      // Sort by addedAt in memory (newest first)
      items.sort((a, b) => b.addedAt.compareTo(a.addedAt));
      return items;
    });
  }

  /// Update shopping item
  Future<void> updateShoppingItem({
    required String itemId,
    bool? isPurchased,
    String? quantity,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (isPurchased != null) updateData['isPurchased'] = isPurchased;
      if (quantity != null) updateData['quantity'] = quantity;

      await _firestore
          .collection(AppConstants.firestoreShoppingList)
          .doc(itemId)
          .update(updateData);
    } catch (e) {
      throw 'Failed to update shopping item: $e';
    }
  }

  /// Delete shopping item
  Future<void> deleteShoppingItem(String itemId) async {
    try {
      await _firestore
          .collection(AppConstants.firestoreShoppingList)
          .doc(itemId)
          .delete();
    } catch (e) {
      throw 'Failed to delete shopping item: $e';
    }
  }

  /// Add multiple items to shopping list from missing ingredients
  Future<void> addMissingIngredientsToShoppingList({
    required String userId,
    required List<String> missingIngredients,
  }) async {
    try {
      final batch = _firestore.batch();

      for (final ingredient in missingIngredients) {
        final item = ShoppingItemModel(
          userId: userId,
          itemName: ingredient,
          quantity: '1',
          isPurchased: false,
          addedAt: DateTime.now(),
        );

        final docRef =
            _firestore.collection(AppConstants.firestoreShoppingList).doc();
        batch.set(docRef, item.toFirestore());
      }

      await batch.commit();
    } catch (e) {
      throw 'Failed to add ingredients to shopping list: $e';
    }
  }

  /// Clear all purchased items from shopping list
  Future<void> clearPurchasedItems(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.firestoreShoppingList)
          .where('userId', isEqualTo: userId)
          .where('isPurchased', isEqualTo: true)
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw 'Failed to clear purchased items: $e';
    }
  }

  /// Alias for clearPurchasedItems for compatibility
  Future<void> clearShoppingList(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.firestoreShoppingList)
          .where('userId', isEqualTo: userId)
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw 'Failed to clear shopping list: $e';
    }
  }

  /// Get shopping list count
  Future<int> getShoppingListCount(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.firestoreShoppingList)
          .where('userId', isEqualTo: userId)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      throw 'Failed to get shopping list count: $e';
    }
  }

  /// Alias for getShoppingListCount for compatibility
  Future<int> getShoppingItemCount(String userId) async {
    return getShoppingListCount(userId);
  }

  // ===== BATCH OPERATIONS =====

  /// Delete all user data (recipes and shopping list)
  Future<void> deleteAllUserData(String userId) async {
    try {
      // Delete recipes
      final recipes = await _firestore
          .collection(AppConstants.firestoreSavedRecipes)
          .where('userId', isEqualTo: userId)
          .get();

      final batch = _firestore.batch();
      for (var doc in recipes.docs) {
        batch.delete(doc.reference);
      }

      // Delete shopping items
      final shoppingItems = await _firestore
          .collection(AppConstants.firestoreShoppingList)
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in shoppingItems.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw 'Failed to delete user data: $e';
    }
  }

  /// Add multiple items to shopping list (avoiding duplicates)
  Future<void> addMultipleShoppingItems(List<ShoppingItemModel> items) async {
    try {
      if (items.isEmpty) return;

      // Get existing items for this user
      final existingSnapshot = await _firestore
          .collection(AppConstants.firestoreShoppingList)
          .where('userId', isEqualTo: items.first.userId)
          .get();

      final existingItemNames = existingSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return (data['itemName'] as String).toLowerCase();
      }).toSet();

      // Filter out duplicates
      final newItems = items
          .where((item) =>
              !existingItemNames.contains(item.itemName.toLowerCase()))
          .toList();

      if (newItems.isEmpty) return;

      final batch = _firestore.batch();

      for (final item in newItems) {
        final docRef =
            _firestore.collection(AppConstants.firestoreShoppingList).doc();
        batch.set(docRef, item.toFirestore());
      }

      await batch.commit();
    } catch (e) {
      throw 'Failed to add multiple items to shopping list: $e';
    }
  }
}
