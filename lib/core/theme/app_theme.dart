import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();
  static const background = Color(0xFF1E1F28);
  static const surface = Color(0xFF2A2B38);
  static const primary = Color(0xFF2FB59A);
  static const accent = Color(0xFFE6E07A);
  static const pink = Color(0xFFE91E8C);
  static const gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF2FA88F), Color(0xFFE6E07A)],
  );
}

class AppTheme {
  const AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          surface: AppColors.surface,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(),
        ),
      );
}
