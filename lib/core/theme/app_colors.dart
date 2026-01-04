import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Dark Mode
  static const Color darkBg = Color(0xFF0F1419); // Deep Grey/Black
  static const Color darkBackground =
      Color(0xFF0F1419); // Deep Grey/Black (alias)
  static const Color darkSurface = Color(0xFF1A1F26); // Dark Grey Surface
  static const Color darkCard = Color(0xFF242B34); // Card Background

  // Accent Colors
  static const Color electricBlue = Color(0xFF00D9FF); // Electric Blue
  static const Color electricBlueDark = Color(0xFF0099CC); // Electric Blue Dark

  // Secondary Colors
  static const Color accentBlue = Color(0xFF2563EB); // Accent Blue
  static const Color success = Color(0xFF10B981); // Success Green
  static const Color warning = Color(0xFFF59E0B); // Warning Orange
  static const Color error = Color(0xFFEF4444); // Error Red

  // Text Colors
  static const Color textPrimary = Color(0xFFF3F4F6); // Light Grey Text
  static const Color textSecondary = Color(0xFF9CA3AF); // Medium Grey Text
  static const Color textTertiary = Color(0xFF6B7280); // Dark Grey Text

  // Borders & Dividers
  static const Color borderColor = Color(0xFF374151); // Border Grey
  static const Color dividerColor = Color(0xFF1F2937); // Divider Grey

  // Gradients
  static const LinearGradient blueGradient = LinearGradient(
    colors: [electricBlue, accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
