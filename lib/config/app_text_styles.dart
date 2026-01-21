import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Global Text Styles following Material 3 typography system
/// Headings use Poppins, body text uses Inter
/// This ensures consistent typography across the entire app
class AppTextStyles {
  // ⚠️ PRIVATE CONSTRUCTOR - Prevents instantiation
  AppTextStyles._();

  // DISPLAY STYLES (Large titles)
  /// Display Large - 57sp / Poppins Bold
  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.12,
        letterSpacing: -0.25,
      );

  /// Display Medium - 45sp / Poppins Bold
  static TextStyle get displayMedium => GoogleFonts.poppins(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.16,
        letterSpacing: 0,
      );

  /// Display Small - 36sp / Poppins Bold
  static TextStyle get displaySmall => GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.22,
        letterSpacing: 0,
      );

  // HEADLINE STYLES
  /// Headline Large - 32sp / Poppins Bold
  static TextStyle get h1 => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.25,
        letterSpacing: 0,
      );

  /// Headline Medium - 28sp / Poppins SemiBold
  static TextStyle get h2 => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.29,
        letterSpacing: 0,
      );

  /// Headline Small - 24sp / Poppins SemiBold
  static TextStyle get h3 => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.33,
        letterSpacing: 0,
      );

  /// Headline Extra Small - 20sp / Poppins SemiBold
  static TextStyle get h4 => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
        letterSpacing: 0.15,
      );

  /// Headline Tiny - 18sp / Poppins SemiBold
  static TextStyle get h5 => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.56,
        letterSpacing: 0.15,
      );

  // TITLE STYLES
  /// Title Large - 22sp / Inter SemiBold
  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.27,
        letterSpacing: 0.15,
      );

  /// Title Medium - 16sp / Inter SemiBold
  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.5,
        letterSpacing: 0.15,
      );

  /// Title Small - 14sp / Inter SemiBold
  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.43,
        letterSpacing: 0.1,
      );

  // BODY STYLES
  /// Body Large - 16sp / Inter Regular
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        height: 1.5,
        letterSpacing: 0.15,
      );

  /// Body Medium - 14sp / Inter Regular
  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        height: 1.43,
        letterSpacing: 0.25,
      );

  /// Body Small - 12sp / Inter Regular
  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        height: 1.33,
        letterSpacing: 0.4,
      );

  // LABEL STYLES
  /// Label Large - 14sp / Inter Medium
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.43,
        letterSpacing: 0.1,
      );

  /// Label Medium - 12sp / Inter Medium
  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.33,
        letterSpacing: 0.5,
      );

  /// Label Small - 11sp / Inter Medium
  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.45,
        letterSpacing: 0.5,
      );

  // SPECIALIZED STYLES
  /// Style for app bar titles
  static TextStyle get appBarTitle => h4.copyWith(
        color: AppColors.textPrimary,
      );

  /// Style for buttons
  static TextStyle get button => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnDark,
        height: 1.5,
        letterSpacing: 0.1,
      );

  /// Style for error messages
  static TextStyle get error => bodyMedium.copyWith(
        color: AppColors.error,
        fontWeight: FontWeight.w500,
      );

  /// Style for success messages
  static TextStyle get success => bodyMedium.copyWith(
        color: AppColors.success,
        fontWeight: FontWeight.w500,
      );

  /// Style for hints
  static TextStyle get hint => bodyMedium.copyWith(
        color: AppColors.textTertiary,
      );

  /// Style for disabled text
  static TextStyle get disabled => bodyMedium.copyWith(
        color: AppColors.disabled,
      );

  /// Style for recipe card titles
  static TextStyle get recipeCardTitle => titleLarge.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  /// Style for recipe details heading
  static TextStyle get recipeDetailHeading => h3.copyWith(
        fontSize: 22,
      );

  /// Style for nutrition values
  static TextStyle get nutritionValue => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryGreen,
      );

  /// Style for nutrition label
  static TextStyle get nutritionLabel => bodySmall.copyWith(
        color: AppColors.textSecondary,
      );

  /// Style for ingredient items
  static TextStyle get ingredientText => bodyLarge.copyWith(
        height: 1.6,
      );

  /// Style for instructions step number
  static TextStyle get stepNumber => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryGreen,
      );

  /// Style for instructions step text
  static TextStyle get stepText => bodyLarge.copyWith(
        height: 1.6,
      );

  /// Style for category badge
  static TextStyle get categoryBadge => labelSmall.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  /// Style for meta information (prep time, difficulty)
  static TextStyle get metaInfo => bodySmall.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  /// Subtitle style 1 (for compatibility with existing code)
  static TextStyle get subtitle1 => titleMedium.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  /// Subtitle style 2 (for compatibility with existing code)
  static TextStyle get subtitle2 => titleSmall.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  /// Caption style (for compatibility with existing code)
  static TextStyle get caption => bodySmall.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  /// Overline style
  static TextStyle get overline => labelSmall.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      );
}
