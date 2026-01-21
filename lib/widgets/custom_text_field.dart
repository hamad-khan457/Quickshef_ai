import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../config/app_constants.dart';

/// Custom text field with consistent styling
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText; // ✅ FIXED: Added obscureText parameter
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false, // ✅ FIXED: Default value
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (focused) {
            setState(() {
              _isFocused = focused;
            });
          },
          child: TextFormField(
            controller: widget.controller,
            obscureText:
                widget.obscureText && _obscureText, // ✅ FIXED: Proper logic
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            style: AppTextStyles.bodyLarge,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textLight,
              ),
              filled: true,
              fillColor: widget.enabled
                  ? AppColors.secondaryCream
                  : AppColors.backgroundLight,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused
                          ? AppColors.primaryGreen
                          : AppColors.textSecondary,
                    )
                  : null,
              suffixIcon: widget
                      .obscureText // ✅ FIXED: Show toggle only for passwords
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : widget.suffixIcon != null
                      ? IconButton(
                          icon: Icon(
                            widget.suffixIcon,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: widget.onSuffixIconTap,
                        )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: const BorderSide(
                  color: AppColors.divider,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: const BorderSide(
                  color: AppColors.divider,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: const BorderSide(
                  color: AppColors.primaryGreen,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: widget.validator,
          ),
        ),
      ],
    );
  }
}

/// Search text field variant
class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Function(String) onChanged;
  final VoidCallback? onClear;

  const SearchTextField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textLight,
        ),
        filled: true,
        fillColor: AppColors.secondaryCream,
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textSecondary,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  controller.clear();
                  if (onClear != null) {
                    onClear!();
                  }
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
