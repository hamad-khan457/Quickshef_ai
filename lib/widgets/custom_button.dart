import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../config/app_constants.dart';

/// Custom button widget with consistent styling
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 56.0,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color btnColor = backgroundColor ?? AppColors.primaryGreen;
    final Color btnTextColor = textColor ?? Colors.white;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: isOutlined
          ? _buildOutlinedButton(btnColor, btnTextColor)
          : _buildFilledButton(btnColor, btnTextColor),
    );
  }

  Widget _buildFilledButton(Color btnColor, Color btnTextColor) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: btnColor,
        foregroundColor: btnTextColor,
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      child: isLoading
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(btnTextColor),
              ),
            )
          : _buildButtonContent(btnTextColor),
    );
  }

  Widget _buildOutlinedButton(Color btnColor, Color btnTextColor) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: btnColor,
        side: BorderSide(color: btnColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      child: isLoading
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(btnColor),
              ),
            )
          : _buildButtonContent(btnColor),
    );
  }

  Widget _buildButtonContent(Color color) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.button.copyWith(color: color),
          ),
        ],
      );
    }

    return Text(
      text,
      style: AppTextStyles.button.copyWith(color: color),
    );
  }
}

/// Secondary button variant
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: AppColors.accentOrange,
    );
  }
}

/// Text button variant
class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const CustomTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? AppColors.primaryGreen,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        text,
        style: AppTextStyles.button.copyWith(
          color: color ?? AppColors.primaryGreen,
          fontSize: 14,
        ),
      ),
    );
  }
}
