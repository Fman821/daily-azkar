import 'package:flutter/material.dart';

/// Refined emerald-and-gold theme for Daily Azkar.
class AppColors {
  AppColors._();

  static const bg = Color(0xFF07130F);
  static const card = Color(0xFF10271E);
  static const cardDeep = Color(0xFF0B2018);
  static const navBg = Color(0xFF091A13);
  static const gold = Color(0xFFE8C46A);
  static const goldSoft = Color(0xFFF3DDA0);
  static const goldDark = Color(0xFF806B36);
  static const orange = Color(0xFFE5A84B);
  static const text = Color(0xFFF5F5EF);
  static const textSoft = Color(0xFFD4E2D8);
  static const muted = Color(0xFF91B3A0);
  static const border = Color(0xFF294A39);
}

ThemeData buildTheme() {
  const scheme = ColorScheme.dark(
    primary: AppColors.gold,
    onPrimary: Color(0xFF211A08),
    secondary: AppColors.goldSoft,
    onSecondary: Color(0xFF211A08),
    surface: AppColors.card,
    onSurface: AppColors.text,
    error: Color(0xFFFF8A80),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.text,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.text,
        fontSize: 21,
        fontWeight: FontWeight.w700,
        letterSpacing: .1,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: AppColors.border, width: .7),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.navBg,
      elevation: 0,
      height: 72,
      indicatorColor: AppColors.gold.withAlpha(38),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
        fontSize: 11,
        fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
        color: states.contains(WidgetState.selected) ? AppColors.gold : AppColors.muted,
      )),
      iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
        size: 23,
        color: states.contains(WidgetState.selected) ? AppColors.gold : AppColors.muted,
      )),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardDeep,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: AppColors.muted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.4),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: const Color(0xFF211A08),
        minimumSize: const Size(0, 50),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: AppColors.gold),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: .7),
  );
}
