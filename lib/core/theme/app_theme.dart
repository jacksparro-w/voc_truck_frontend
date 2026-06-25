import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF12304A);
  static const Color accent = Color(0xFFF97316);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Colors.white;
  static const Color text = Color(0xFF172033);

  static ThemeData light = ThemeData(
    useMaterial3: true,
    fontFamily: "Roboto",
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: accent,
      tertiary: success,
      error: Color(0xFFDC2626),
      surface: surface,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: primary,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(
          color: Color(0xFFE4E9F0),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD7DEE8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD7DEE8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accent, width: 1.6),
      ),
      labelStyle: const TextStyle(color: Color(0xFF65748B)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: accent,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        minimumSize: const Size.fromHeight(50),
        side: const BorderSide(color: Color(0xFFCBD5E1)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: text,
        fontWeight: FontWeight.w800,
      ),
      titleLarge: TextStyle(
        color: text,
        fontWeight: FontWeight.w800,
      ),
      titleMedium: TextStyle(
        color: text,
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF44546A),
      ),
    ),
  );
}
