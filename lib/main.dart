import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/app_colors.dart';
import 'config/app_text_styles.dart';
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';

/// Firebase configuration for web
/// IMPORTANT: Replace with your actual Firebase project configuration
const firebaseConfig = FirebaseOptions(
  apiKey: "your-api-key-here",
  authDomain: "your-project-id.firebaseapp.com",
  projectId: "your-id-here",
  storageBucket: "your-project-id.firebasestorage.app",
  messagingSenderId: "your-masseging-id",
  appId: "1:your_masseging-id:web:web-masseging-id",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: firebaseConfig,
  );

  runApp(const QuickChefApp());
}

class QuickChefApp extends StatelessWidget {
  const QuickChefApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        title: 'QuickChef AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,

          // Color scheme
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryGreen,
            primary: AppColors.primaryGreen,
            secondary: AppColors.accentOrange,
            background: AppColors.backgroundLight,
            surface: AppColors.cardBackground,
          ),

          // Scaffold background
          scaffoldBackgroundColor: AppColors.backgroundLight,

          // App bar theme
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.cardBackground,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: AppTextStyles.h4,
          ),

          // Card theme
          cardTheme: CardThemeData(
            color: AppColors.cardBackground,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          // Elevated button theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: AppTextStyles.button,
            ),
          ),

          // Text button theme
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
              textStyle: AppTextStyles.button,
            ),
          ),

          // Input decoration theme
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.secondaryCream,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),

          // Chip theme
          chipTheme: ChipThemeData(
            backgroundColor: AppColors.secondaryCream,
            labelStyle: AppTextStyles.bodySmall,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // Divider theme
          dividerTheme: const DividerThemeData(
            color: AppColors.divider,
            thickness: 1,
            space: 24,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
