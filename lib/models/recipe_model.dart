import 'package:cloud_firestore/cloud_firestore.dart';

/// Recipe model matching Firestore schema
/// Represents a complete recipe with all nutritional and ingredient information
class RecipeModel {
  final String? recipeId;
  final String userId;
  final String recipeName;
  final List<String> ingredients;
  final List<String> missingIngredients;
  final List<String> instructions;
  final String prepTime;
  final int calories;
  final String protein;
  final String carbs;
  final String fats;
  final String category;
  final String difficulty;
  final DateTime createdAt;

  RecipeModel({
    this.recipeId,
    required this.userId,
    required this.recipeName,
    required this.ingredients,
    required this.missingIngredients,
    required this.instructions,
    required this.prepTime,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.category,
    required this.difficulty,
    required this.createdAt,
  });

  /// Convert RecipeModel to Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'recipeName': recipeName,
      'ingredients': ingredients,
      'missingIngredients': missingIngredients,
      'instructions': instructions,
      'prepTime': prepTime,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'category': category,
      'difficulty': difficulty,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Create RecipeModel from Firestore document
  factory RecipeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeModel(
      recipeId: doc.id,
      userId: data['userId'] ?? '',
      recipeName: data['recipeName'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      missingIngredients: List<String>.from(data['missingIngredients'] ?? []),
      instructions: List<String>.from(data['instructions'] ?? []),
      prepTime: data['prepTime'] ?? '30 min',
      calories: (data['calories'] ?? 0).toInt(),
      protein: data['protein'] ?? '0g',
      carbs: data['carbs'] ?? '0g',
      fats: data['fats'] ?? '0g',
      category: data['category'] ?? 'General',
      difficulty: data['difficulty'] ?? 'Medium',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Create RecipeModel from Map (useful for JSON parsing)
  factory RecipeModel.fromMap(String recipeId, Map<String, dynamic> map) {
    return RecipeModel(
      recipeId: recipeId,
      userId: map['userId'] ?? '',
      recipeName: map['recipeName'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
      missingIngredients: List<String>.from(map['missingIngredients'] ?? []),
      instructions: List<String>.from(map['instructions'] ?? []),
      prepTime: map['prepTime'] ?? '30 min',
      calories: (map['calories'] ?? 0).toInt(),
      protein: map['protein'] ?? '0g',
      carbs: map['carbs'] ?? '0g',
      fats: map['fats'] ?? '0g',
      category: map['category'] ?? 'General',
      difficulty: map['difficulty'] ?? 'Medium',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Create RecipeModel from JSON (alias for fromMap)
  factory RecipeModel.fromJson(Map<String, dynamic> json, String userId) {
    return RecipeModel(
      userId: userId,
      recipeName: json['recipeName'] ?? json['name'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      missingIngredients: List<String>.from(
          json['missingIngredients'] ?? json['missing_ingredients'] ?? []),
      instructions:
          List<String>.from(json['instructions'] ?? json['steps'] ?? []),
      prepTime: json['prepTime'] ?? json['prep_time'] ?? '30 min',
      calories: (json['calories'] ?? 0).toInt(),
      protein: json['protein'] ?? '0g',
      carbs: json['carbs'] ?? '0g',
      fats: json['fats'] ?? '0g',
      category: json['category'] ?? json['type'] ?? 'General',
      difficulty: json['difficulty'] ?? 'Medium',
      createdAt: DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'userId': userId,
      'recipeName': recipeName,
      'ingredients': ingredients,
      'missingIngredients': missingIngredients,
      'instructions': instructions,
      'prepTime': prepTime,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'category': category,
      'difficulty': difficulty,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  RecipeModel copyWith({
    String? recipeId,
    String? userId,
    String? recipeName,
    List<String>? ingredients,
    List<String>? missingIngredients,
    List<String>? instructions,
    String? prepTime,
    int? calories,
    String? protein,
    String? carbs,
    String? fats,
    String? category,
    String? difficulty,
    DateTime? createdAt,
  }) {
    return RecipeModel(
      recipeId: recipeId ?? this.recipeId,
      userId: userId ?? this.userId,
      recipeName: recipeName ?? this.recipeName,
      ingredients: ingredients ?? this.ingredients,
      missingIngredients: missingIngredients ?? this.missingIngredients,
      instructions: instructions ?? this.instructions,
      prepTime: prepTime ?? this.prepTime,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'RecipeModel(recipeId: $recipeId, recipeName: $recipeName, userId: $userId, calories: $calories)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecipeModel &&
        recipeId == other.recipeId &&
        userId == other.userId &&
        recipeName == other.recipeName &&
        calories == other.calories;
  }

  @override
  int get hashCode {
    return recipeId.hashCode ^
        userId.hashCode ^
        recipeName.hashCode ^
        calories.hashCode;
  }
}
