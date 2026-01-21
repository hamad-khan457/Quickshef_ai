import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../config/app_constants.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'home_screen.dart';

/// Authentication screen for login and registration
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await _authService.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        _showSuccess(AppConstants.successLoginComplete);
      } else {
        await _authService.registerWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
        );
        _showSuccess(AppConstants.successAccountCreated);
      }

      // Navigate to home screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and title
                  _buildHeader(),
                  const SizedBox(height: 48),

                  // Auth form card
                  Card(
                    elevation: AppConstants.cardElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadius),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Mode toggle tabs
                            _buildModeTabs(),
                            const SizedBox(height: 24),

                            // Name field (register only)
                            if (!_isLogin) ...[
                              CustomTextField(
                                controller: _nameController,
                                label: 'Full Name',
                                hint: 'Enter your name',
                                prefixIcon: Icons.person,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppConstants.errorEmptyName;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Email field
                            CustomTextField(
                              controller: _emailController,
                              label: 'Email',
                              hint: 'Enter your email',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppConstants.errorEmptyEmail;
                                }
                                if (!value.contains('@')) {
                                  return AppConstants.errorInvalidEmail;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password field
                            CustomTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: 'Enter your password',
                              obscureText: true,
                              prefixIcon: Icons.lock,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppConstants.errorEmptyPassword;
                                }
                                if (value.length < 6) {
                                  return AppConstants.errorWeakPassword;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Submit button
                            CustomButton(
                              text: _isLogin ? 'Sign In' : 'Create Account',
                              onPressed: _handleSubmit,
                              isLoading: _isLoading,
                            ),
                            const SizedBox(height: 16),

                            // Toggle mode button
                            CustomTextButton(
                              text: _isLogin
                                  ? "Don't have an account? Sign Up"
                                  : 'Already have an account? Sign In',
                              onPressed: _toggleMode,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradientLinear,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.restaurant_menu,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppConstants.appName,
          style: AppTextStyles.h2.copyWith(
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppConstants.appTagline,
          style: AppTextStyles.subtitle1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModeTabs() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (!_isLogin) _toggleMode();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        _isLogin ? AppColors.primaryGreen : AppColors.divider,
                    width: _isLogin ? 3 : 1,
                  ),
                ),
              ),
              child: Text(
                'Sign In',
                style: AppTextStyles.subtitle1.copyWith(
                  color: _isLogin
                      ? AppColors.primaryGreen
                      : AppColors.textSecondary,
                  fontWeight: _isLogin ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (_isLogin) _toggleMode();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        !_isLogin ? AppColors.primaryGreen : AppColors.divider,
                    width: !_isLogin ? 3 : 1,
                  ),
                ),
              ),
              child: Text(
                'Sign Up',
                style: AppTextStyles.subtitle1.copyWith(
                  color: !_isLogin
                      ? AppColors.primaryGreen
                      : AppColors.textSecondary,
                  fontWeight: !_isLogin ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
