import 'package:flutter/material.dart';

class AppTheme {
  // Design tokens
  static const kCardRadius = BorderRadius.all(Radius.circular(16));
  static const kButtonRadius = BorderRadius.all(Radius.circular(12));
  static const kInputRadius = BorderRadius.all(Radius.circular(10));

  static const kSpacingS = 8.0;
  static const kSpacingM = 16.0;
  static const kSpacingL = 24.0;
  static const kSpacingXL = 32.0;

  // Primary brand color
  static const kPrimaryColor = Color(0xFF2563EB);  // professional blue
  static const kAccentColor = Color(0xFF7C3AED);   // purple accent

  // Light theme
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF7F8FC),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: kButtonRadius),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kPrimaryColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: const OutlineInputBorder(
        borderRadius: kInputRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: kInputRadius,
        borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
      ),
    ),
  );

  // Dark theme
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF12121A),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4F8EF7),
      secondary: Color(0xFF7C3AED),
      surface: Color(0xFF1E1E2E),
      onSurface: Colors.white,           // ALL surface text white
      onSurfaceVariant: Color(0xFFCDD0D8), // secondary text clearly visible
      surfaceContainerHighest: Color(0xFF2A2A3E),
      onPrimary: Colors.white,
      error: Color(0xFFFF6B6B),
    ),
    cardColor: const Color(0xFF1E1E2E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A2E),
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Color(0xFFCDD0D8)),
      bodySmall: TextStyle(color: Color(0xFFAAAAAA)),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white),
      labelSmall: TextStyle(color: Color(0xFFAAAAAA)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A3E),
      hintStyle: const TextStyle(color: Color(0xFF7A7A9A)),
      labelStyle: const TextStyle(color: Color(0xFFCDD0D8)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF4F8EF7), width: 1.5)),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      textStyle: TextStyle(color: Colors.white),
    ),
    dividerColor: const Color(0xFF2A2A3E),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: kButtonRadius),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kPrimaryColor,
      ),
    ),
  );
}
