// lib/utils/app_theme.dart
// Centralized colors and theme for the app

import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors
  static const Color primaryColor = Color(0xFF1565C0); // deep blue
  static const Color accentColor = Color(0xFF00ACC1); // teal
  static const Color successColor = Color(0xFF2E7D32); // green
  static const Color warningColor = Color(0xFFF57F17); // amber
  static const Color dangerColor = Color(0xFFC62828); // red
  static const Color surfaceColor = Color(0xFFF5F7FA);
  static const Color cardColor = Colors.white;

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: surfaceColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
      // FIX: Flutter 3.x requires CardThemeData, not CardTheme
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDE2E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDE2E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: dangerColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: Color(0xFF6B7280)),
      ),
    );
  }
}
