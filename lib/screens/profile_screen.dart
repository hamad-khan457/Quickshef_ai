import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../config/app_constants.dart';
import '../widgets/custom_button.dart';
import 'auth_screen.dart';

/// Profile Screen - User settings and account management
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _currentUser;
  int _recipeCount = 0;
  int _shoppingItemCount = 0;
  bool _isLoading = true;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final userId = _authService.currentUserId;
      if (userId == null) return;

      final user = await _authService.getUserData(userId);
      final recipeCount = await _firestoreService.getRecipeCount(userId);
      final shoppingCount =
          await _firestoreService.getShoppingItemCount(userId);

      setState(() {
        _currentUser = user;
        _recipeCount = recipeCount;
        _shoppingItemCount = shoppingCount;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load profile: ${e.toString()}');
    }
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
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
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoggingOut = true);

      try {
        await _authService.signOut();

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AuthScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        _showError('Failed to sign out: ${e.toString()}');
        setState(() => _isLoggingOut = false);
      }
    }
  }

  Future<void> _clearSavedData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Data'),
        content: const Text(
          'This will delete all your saved recipes and shopping list items. This action cannot be undone.',
        ),
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
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final userId = _authService.currentUserId!;
        await _firestoreService.clearShoppingList(userId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data cleared successfully'),
            backgroundColor: AppColors.success,
          ),
        );

        await _loadUserData();
      } catch (e) {
        _showError('Failed to clear data: ${e.toString()}');
      }
    }
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
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
        ),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile header
            _buildProfileHeader(),
            const SizedBox(height: 32),

            // Stats cards
            _buildStatsCards(),
            const SizedBox(height: 32),

            // Settings sections
            _buildSettingsSection(),
            const SizedBox(height: 24),

            // Danger zone
            _buildDangerZone(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradientLinear,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  (_currentUser?.name.isNotEmpty == true)
                      ? _currentUser!.name[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: 48,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              _currentUser?.name ?? 'User',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              _currentUser?.email ?? '',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.bookmark,
            label: 'Saved Recipes',
            value: '$_recipeCount',
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.shopping_cart,
            label: 'Shopping Items',
            value: '$_shoppingItemCount',
            color: AppColors.accentOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: AppTextStyles.h3.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: AppConstants.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Column(
            children: [
              _buildSettingsItem(
                icon: Icons.account_circle,
                title: 'Account',
                subtitle: 'Manage your account settings',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account settings coming soon!'),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _buildSettingsItem(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notification settings coming soon!'),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _buildSettingsItem(
                icon: Icons.help,
                title: 'Help & Support',
                subtitle: 'Get help and contact support',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Help section coming soon!'),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _buildSettingsItem(
                icon: Icons.info,
                title: 'About',
                subtitle: 'Version ${AppConstants.appVersion}',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: AppConstants.appName,
                    applicationVersion: AppConstants.appVersion,
                    applicationLegalese: '© 2024 QuickChef AI',
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(
        title,
        style: AppTextStyles.subtitle1,
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption,
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textLight,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDangerZone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danger Zone',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.error,
          ),
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Clear Saved Data',
          onPressed: _clearSavedData,
          backgroundColor: AppColors.error.withOpacity(0.1),
          textColor: AppColors.error,
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Sign Out',
          onPressed: _signOut,
          isLoading: _isLoggingOut,
          backgroundColor: AppColors.error,
          icon: Icons.logout,
        ),
      ],
    );
  }
}
