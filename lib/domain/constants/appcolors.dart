// lib/constants/app_colors.dart
import 'package:flutter/material.dart';

enum ColorScheme { green, blue, purple, orange }

class AppColors {
  // Green Theme (Your current colors)
  static const Color greenPrimary = Color(0xFF2E481E);
  static const Color greenButtonPrimary = Color(0xFF569033);
  static const Color greenLight = Color(0xFF7CB342);
  static const Color greenDark = Color(0xFF1B5E20);

  // Blue Theme
  static const Color bluePrimary = Color(0xFF1E3A8A);
  static const Color blueButtonPrimary = Color(0xFF3B82F6);
  static const Color blueLight = Color(0xFF60A5FA);
  static const Color blueDark = Color(0xFF1E40AF);

  // Purple Theme
  static const Color purplePrimary = Color(0xFF581C87);
  static const Color purpleButtonPrimary = Color(0xFF8B5CF6);
  static const Color purpleLight = Color(0xFFA78BFA);
  static const Color purpleDark = Color(0xFF6B21A8);

  // Orange Theme
  static const Color orangePrimary = Color(0xFF9A3412);
  static const Color orangeButtonPrimary = Color(0xFFEA580C);
  static const Color orangeLight = Color(0xFFFB923C);
  static const Color orangeDark = Color(0xFFDC2626);

  // Common colors (unchanged across themes)
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color error = Color(0xFFE53E3E);
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFED8936);

  // Get colors based on selected scheme
  static Color getPrimaryColor(ColorScheme scheme) {
    switch (scheme) {
      case ColorScheme.green:
        return greenPrimary;
      case ColorScheme.blue:
        return bluePrimary;
      case ColorScheme.purple:
        return purplePrimary;
      case ColorScheme.orange:
        return orangePrimary;
    }
  }

  static Color getButtonPrimaryColor(ColorScheme scheme) {
    switch (scheme) {
      case ColorScheme.green:
        return greenButtonPrimary;
      case ColorScheme.blue:
        return blueButtonPrimary;
      case ColorScheme.purple:
        return purpleButtonPrimary;
      case ColorScheme.orange:
        return orangeButtonPrimary;
    }
  }

  static Color getLightColor(ColorScheme scheme) {
    switch (scheme) {
      case ColorScheme.green:
        return greenLight;
      case ColorScheme.blue:
        return blueLight;
      case ColorScheme.purple:
        return purpleLight;
      case ColorScheme.orange:
        return orangeLight;
    }
  }

  static Color getDarkColor(ColorScheme scheme) {
    switch (scheme) {
      case ColorScheme.green:
        return greenDark;
      case ColorScheme.blue:
        return blueDark;
      case ColorScheme.purple:
        return purpleDark;
      case ColorScheme.orange:
        return orangeDark;
    }
  }

  // Get gradient based on scheme
  static LinearGradient getGradient(ColorScheme scheme) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [getPrimaryColor(scheme), getButtonPrimaryColor(scheme)],
    );
  }
}
