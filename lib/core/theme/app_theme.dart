import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _titleTextStyle(),
      ),
      primaryColor: AppColors.electricBlue,
      colorScheme: ColorScheme.dark(
        primary: AppColors.electricBlue,
        secondary: AppColors.accentBlue,
        surface: AppColors.darkSurface,
        error: AppColors.error,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.electricBlue,
          foregroundColor: AppColors.darkBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.electricBlue,
          side: BorderSide(color: AppColors.electricBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        contentPadding: EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.electricBlue, width: 2),
        ),
        hintStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontFamily: 'Poppins',
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: _headlineLarge(),
        headlineMedium: _headlineMedium(),
        titleLarge: _titleTextStyle(),
        titleMedium: _titleMedium(),
        bodyLarge: _bodyLarge(),
        bodyMedium: _bodyMedium(),
        labelSmall: _labelSmall(),
      ),
    );
  }

  // Text Styles
  static TextStyle _headlineLarge() {
    return TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle _headlineMedium() {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle _titleTextStyle() {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle _titleMedium() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle _bodyLarge() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle _bodyMedium() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle _labelSmall() {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textTertiary,
      fontFamily: 'Poppins',
    );
  }
}
