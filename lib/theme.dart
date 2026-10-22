import 'package:flutter/material.dart';

/// Dark green and gold palette taken from the original mockup.
class AppColors {
  AppColors._();

  static const bg = Color(0xFF04170F);
  static const card = Color(0xFF0B2C1F);
  static const cardDeep = Color(0xFF08241A);
  static const navBg = Color(0xFF05200F);
  static const gold = Color(0xFFF0B800);
  static const goldSoft = Color(0xFFD9A92C);
  static const goldDark = Color(0xFF8A6D12);
  static const orange = Color(0xFFF08C00);
  static const text = Color(0xFFE9EFE9);
  static const textSoft = Color(0xFFCFE3D6);
  static const muted = Color(0xFF7FBF9F);
  static const border = Color(0xFF1B4A35);
}

ThemeData buildTheme() {
  final scheme = ColorScheme.dark(
    primary: AppColors.gold,
    onPrimary: const Color(0xFF2A1700),
    secondary: AppColors.goldSoft,
    onSecondary: const Color(0xFF2A1700),
    surface: AppColors.card,
    onSurface: AppColors.text,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.gold,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.gold,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.navBg,
      indicatorColor: AppColors.gold.withAlpha(45),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          color: states.contains(WidgetState.selected)
              ? AppColors.gold
              : AppColors.muted,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? AppColors.gold
              : AppColors.muted,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.goldDark),
      ),
    ),
  );
}
