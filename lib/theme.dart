import 'package:flutter/material.dart';

/// Emerald and champagne palette. Names stay the same across the app, so a
/// change here updates every screen.
class AppColors {
  AppColors._();

  static const bg = Color(0xFF021A14);
  static const card = Color(0xFF0A3228);
  static const cardDeep = Color(0xFF072820);
  static const navBg = Color(0xFF04231B);
  static const gold = Color(0xFFF4C95D);
  static const goldSoft = Color(0xFFE6B95E);
  static const goldDark = Color(0xFF9C7A22);
  static const orange = Color(0xFFFF9F43);
  static const accent = Color(0xFF38C8A0);
  static const text = Color(0xFFF2F8F4);
  static const textSoft = Color(0xFFD0E8DA);
  static const muted = Color(0xFF8FCBB0);
  static const border = Color(0xFF235E4A);
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
