import 'package:flutter/material.dart';

/// Global Color Scheme following Material 3 principles
/// All colors are professionally designed for academic/production use
class AppColors {
  // ⚠️ PRIVATE CONSTRUCTOR - Prevents instantiation
  AppColors._();

  // PRIMARY COLORS
  /// Deep Green - Primary brand color
  static const Color primaryGreen = Color(0xFF2E7D32);

  /// Darker green for hover/pressed states
  static const Color primaryGreenDark = Color(0xFF1B5E20);

  /// Lighter green for backgrounds
  static const Color primaryGreenLight = Color(0xFFC8E6C9);

  // SECONDARY COLORS
  /// Soft Cream - Secondary brand color
  static const Color secondaryCream = Color(0xFFFAF9F6);

  /// Warm Orange - Accent color
  static const Color accentOrange = Color(0xFFFF8F00);

  /// Darker orange for interactive states
  static const Color accentOrangeDark = Color(0xFFE65100);

  // BACKGROUND COLORS
  /// Light neutral background
  static const Color backgroundLight = Color(0xFFF5F5F5);

  /// White background for cards and overlays
  static const Color cardBackground = Color(0xFFFFFFFF);

  /// Slightly darker background for depth
  static const Color backgroundSecondary = Color(0xFFFAFAFA);

  // TEXT COLORS
  /// Primary text color - High contrast
  static const Color textPrimary = Color(0xFF212121);

  /// Secondary text color - Medium contrast
  static const Color textSecondary = Color(0xFF616161);

  /// Tertiary text color - Low contrast
  static const Color textTertiary = Color(0xFF9E9E9E);

  /// Text on dark backgrounds
  static const Color textOnDark = Color(0xFFFFFFFF);

  // SEMANTIC COLORS
  /// Success state - Green
  static const Color success = Color(0xFF4CAF50);

  /// Error state - Red
  static const Color error = Color(0xFFD32F2F);

  /// Warning state - Amber
  static const Color warning = Color(0xFFFFA000);

  /// Info state - Blue
  static const Color info = Color(0xFF1976D2);

  // NEUTRAL COLORS
  /// Light gray for borders
  static const Color borderLight = Color(0xFFE0E0E0);

  /// Medium gray for dividers
  static const Color divider = Color(0xFFBDBDBD);

  /// Disabled state color
  static const Color disabled = Color(0xFFCFCFCF);

  // OVERLAY COLORS
  /// Semi-transparent overlay for modals
  static const Color overlayDark = Color(0x80000000);

  /// Semi-transparent overlay light
  static const Color overlayLight = Color(0x1F000000);

  // GRADIENT COLORS
  /// Primary gradient start
  static const Color gradientStart = primaryGreen;

  /// Primary gradient end
  static const Color gradientEnd = Color(0xFF43A047);

  // DIFFICULTY LEVEL COLORS
  /// Easy recipes
  static const Color difficultyEasy = Color(0xFF66BB6A);

  /// Medium recipes
  static const Color difficultyMedium = Color(0xFFFFA726);

  /// Hard recipes
  static const Color difficultyHard = Color(0xFFEF5350);

  // MATERIAL 3 COLORS
  /// Material 3 error color
  static const Color material3Error = Color(0xFFB3261E);

  /// Material 3 outline color
  static const Color material3Outline = Color(0xFF79747E);

  /// Material 3 outline variant
  static const Color material3OutlineVariant = Color(0xFFCAC7D0);

  /// Category colors (for recipe categories)
  /// Vegetarian recipes
  static const Color categoryVegetarian = Color(0xFF4CAF50);

  /// Non-vegetarian recipes
  static const Color categoryNonVegetarian = Color(0xFFFF6F00);

  /// Vegan recipes
  static const Color categoryVegan = Color(0xFF8BC34A);

  /// Gluten-free recipes
  static const Color categoryGlutenFree = Color(0xFF00BCD4);

  // ADDITIONAL COMPATIBILITY COLORS
  /// Light text color (for compatibility)
  static const Color textLight = Color(0xFF9E9E9E);

  /// Primary gradient (as LinearGradient)
  static LinearGradient get primaryGradientLinear => LinearGradient(
        colors: [primaryGreen, Color(0xFF43A047)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Primary gradient color for containers (single color for backward compatibility)
  static const Color primaryGradient = primaryGreen;

  /// Secondary gradient color
  static const Color secondaryGradient = Color(0xFF43A047);
}
