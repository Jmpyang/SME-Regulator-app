import 'package:flutter/material.dart';

/// Improved theme implementation following Material 3 design system
/// with proper semantic colors, typography scale, and accessibility
class AppTheme {
  // Design tokens
  static const kCardRadius = BorderRadius.all(Radius.circular(16));
  static const kButtonRadius = BorderRadius.all(Radius.circular(12));
  static const kInputRadius = BorderRadius.all(Radius.circular(10));

  static const kSpacingS = 8.0;
  static const kSpacingM = 16.0;
  static const kSpacingL = 24.0;
  static const kSpacingXL = 32.0;

  // Brand colors
  static const kPrimaryColor = Color(0xFF2563EB);
  static const kAccentColor = Color(0xFF7C3AED);

  // Semantic colors (light theme)
  static const kSuccessColor = Color(0xFF10B981);
  static const kWarningColor = Color(0xFFF59E0B);
  static const kInfoColor = Color(0xFF3B82F6);
  static const kErrorColor = Color(0xFFEF4444);

  // Typography scale
  static const kTextScale = TextScaler.linear(1.0);
  
  // Font weights
  static const kFontWeightLight = FontWeight.w300;
  static const kFontWeightRegular = FontWeight.w400;
  static const kFontWeightMedium = FontWeight.w500;
  static const kFontWeightSemiBold = FontWeight.w600;
  static const kFontWeightBold = FontWeight.w700;
  static const kFontWeightExtraBold = FontWeight.w800;
  static const kFontWeightBlack = FontWeight.w900;

  // Light theme
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimaryColor,
      brightness: Brightness.light,
      // Override semantic colors for better visibility
      error: kErrorColor,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    
    // Typography theme with proper scale
    textTheme: _buildLightTextTheme(),
    
    // App bar theme
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    
    // Card theme
    cardTheme: const CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: kCardRadius),
      color: Colors.white,
    ),
    
    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: kButtonRadius),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: kFontWeightSemiBold,
        ),
      ),
    ),
    
    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: kButtonRadius),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: kFontWeightMedium,
        ),
      ),
    ),
    
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: kInputRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: kInputRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: kInputRadius,
        borderSide: BorderSide(color: kPrimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: kInputRadius,
        borderSide: const BorderSide(color: kErrorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: kInputRadius,
        borderSide: const BorderSide(color: kErrorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    
    // Divider theme
    dividerTheme: const DividerThemeData(
      space: 1,
      thickness: 1,
      color: Color(0xFFE5E7EB),
    ),
  );

  // Dark theme
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimaryColor,
      brightness: Brightness.dark,
      // Override semantic colors for better visibility
      error: kErrorColor,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    
    // Typography theme with proper scale
    textTheme: _buildDarkTextTheme(),
    
    // App bar theme
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Color(0xFF1E293B),
    ),
    
    // Card theme
    cardTheme: const CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: kCardRadius),
      color: Color(0xFF1E293B),
    ),
    
    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: kButtonRadius),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: kFontWeightSemiBold,
        ),
      ),
    ),
    
    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: kButtonRadius),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: kFontWeightMedium,
        ),
      ),
    ),
    
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF334155),
      border: OutlineInputBorder(
        borderRadius: kInputRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: kInputRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: kInputRadius,
        borderSide: const BorderSide(color: kPrimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: kInputRadius,
        borderSide: const BorderSide(color: kErrorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: kInputRadius,
        borderSide: const BorderSide(color: kErrorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    
    // Divider theme
    dividerTheme: const DividerThemeData(
      space: 1,
      thickness: 1,
      color: Color(0xFF334155),
    ),
  );

  // Light theme text scale
  static TextTheme _buildLightTextTheme() {
    return const TextTheme(
      // Display styles (rarely used)
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: kFontWeightRegular,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: kFontWeightRegular,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: kFontWeightRegular,
      ),
      
      // Headline styles
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: kFontWeightSemiBold,
        color: Color(0xFF111827),
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: kFontWeightSemiBold,
        color: Color(0xFF111827),
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: kFontWeightSemiBold,
        color: Color(0xFF111827),
      ),
      
      // Title styles
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: kFontWeightSemiBold,
        color: Color(0xFF111827),
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: kFontWeightMedium,
        color: Color(0xFF111827),
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: kFontWeightMedium,
        color: Color(0xFF111827),
      ),
      
      // Body styles
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: kFontWeightRegular,
        color: Color(0xFF1F2937),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: kFontWeightRegular,
        color: Color(0xFF4B5563),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: kFontWeightRegular,
        color: Color(0xFF6B7280),
      ),
      
      // Label styles
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: kFontWeightMedium,
        color: Color(0xFF374151),
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: kFontWeightMedium,
        color: Color(0xFF6B7280),
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: kFontWeightMedium,
        color: Color(0xFF9CA3AF),
      ),
    );
  }

  // Dark theme text scale
  static TextTheme _buildDarkTextTheme() {
    return const TextTheme(
      // Display styles (rarely used)
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: kFontWeightRegular,
        letterSpacing: -0.25,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: kFontWeightRegular,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: kFontWeightRegular,
        color: Colors.white,
      ),
      
      // Headline styles
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: kFontWeightSemiBold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: kFontWeightSemiBold,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: kFontWeightSemiBold,
        color: Colors.white,
      ),
      
      // Title styles
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: kFontWeightSemiBold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: kFontWeightMedium,
        color: Color(0xFFE5E7EB),
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: kFontWeightMedium,
        color: Color(0xFFD1D5DB),
      ),
      
      // Body styles
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: kFontWeightRegular,
        color: Color(0xFFE5E7EB),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: kFontWeightRegular,
        color: Color(0xFF9CA3AF),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: kFontWeightRegular,
        color: Color(0xFF6B7280),
      ),
      
      // Label styles
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: kFontWeightMedium,
        color: Color(0xFFD1D5DB),
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: kFontWeightMedium,
        color: Color(0xFF9CA3AF),
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: kFontWeightMedium,
        color: Color(0xFF6B7280),
      ),
    );
  }
}

/// Extension methods for easy access to semantic colors
extension ThemeColors on ColorScheme {
  Color get success => AppTheme.kSuccessColor;
  Color get warning => AppTheme.kWarningColor;
  Color get info => AppTheme.kInfoColor;
}

/// Extension methods for easy access to text styles
extension ThemeText on TextTheme {
  TextStyle get display => headlineLarge!;
  TextStyle get heading => headlineMedium!;
  TextStyle get subheading => headlineSmall!;
  TextStyle get body => bodyMedium!;
  TextStyle get caption => bodySmall!;
}
