// lib/controllers/color_scheme_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart' as material;
import 'package:plant_app/domain/constants/appcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorSchemeController extends GetxController {
  Rx<ColorScheme> currentColorScheme = ColorScheme.green.obs;
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadColorSchemePreference();
    _loadDarkModePreference();
  }

  // Make this public so it can be called from main.dart
  Future<void> loadColorSchemePreference() async {
    return _loadColorSchemePreference();
  }

  void _loadColorSchemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedScheme = prefs.getString('colorScheme') ?? 'green';

      switch (savedScheme) {
        case 'green':
          currentColorScheme.value = ColorScheme.green;
          break;
        case 'blue':
          currentColorScheme.value = ColorScheme.blue;
          break;
        case 'purple':
          currentColorScheme.value = ColorScheme.purple;
          break;
        case 'orange':
          currentColorScheme.value = ColorScheme.orange;
          break;
        default:
          currentColorScheme.value = ColorScheme.green;
      }
    } catch (e) {
      // Handle error gracefully
      currentColorScheme.value = ColorScheme.green;
    }
  }

  Future<void> loadDarkModePreference() async {
    return _loadDarkModePreference();
  }

  void _loadDarkModePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedDark = prefs.getBool('darkMode') ?? false;
      isDarkMode.value = savedDark;
    } catch (e) {
      isDarkMode.value = false;
    }
  }

  Future<void> setDarkMode(bool value) async {
    isDarkMode.value = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('darkMode', value);
      // Update theme
      Get.changeTheme(getThemeData(currentColorScheme.value));
    } catch (e) {
      print('Error saving dark mode: $e');
    }
  }

  void changeColorScheme(ColorScheme scheme) async {
    currentColorScheme.value = scheme;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('colorScheme', scheme.name);
      // Update theme
      Get.changeTheme(getThemeData(scheme));
    } catch (e) {
      // Handle error if needed
      print('Error saving color scheme: $e');
    }
  }

  material.ThemeData getThemeData(ColorScheme scheme) {
    if (isDarkMode.value) {
      return material.ThemeData(
        useMaterial3: true,
        brightness: material.Brightness.dark,
        colorScheme: material.ColorScheme.dark(
          primary: AppColors.getPrimaryColor(scheme),
          secondary: AppColors.getButtonPrimaryColor(scheme),
          surface: material.Colors.grey[900]!,
          onPrimary: material.Colors.white,
          onSecondary: material.Colors.white,
          onSurface: material.Colors.white,
          error: AppColors.error,
        ),
        appBarTheme: material.AppBarTheme(
          backgroundColor: AppColors.getPrimaryColor(scheme),
          foregroundColor: material.Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: material.ElevatedButtonThemeData(
          style: material.ElevatedButton.styleFrom(
            backgroundColor: AppColors.getButtonPrimaryColor(scheme),
            foregroundColor: material.Colors.white,
            shape: material.RoundedRectangleBorder(
              borderRadius: material.BorderRadius.circular(12),
            ),
            padding: const material.EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 24,
            ),
          ),
        ),
        floatingActionButtonTheme: material.FloatingActionButtonThemeData(
          backgroundColor: AppColors.getButtonPrimaryColor(scheme),
          foregroundColor: material.Colors.white,
        ),
        textTheme: const material.TextTheme(
          headlineLarge: material.TextStyle(
            color: material.Colors.white,
            fontSize: 32,
            fontWeight: material.FontWeight.bold,
          ),
          headlineMedium: material.TextStyle(
            color: material.Colors.white,
            fontSize: 28,
            fontWeight: material.FontWeight.w600,
          ),
          bodyLarge: material.TextStyle(
            color: material.Colors.white,
            fontSize: 16,
          ),
          bodyMedium: material.TextStyle(
            color: material.Colors.white70,
            fontSize: 14,
          ),
        ),
        inputDecorationTheme: material.InputDecorationTheme(
          filled: true,
          fillColor: material.Colors.grey[900],
          border: material.OutlineInputBorder(
            borderRadius: material.BorderRadius.circular(12),
            borderSide: material.BorderSide(color: material.Colors.white24),
          ),
          focusedBorder: material.OutlineInputBorder(
            borderRadius: material.BorderRadius.circular(12),
            borderSide: material.BorderSide(
              color: AppColors.getButtonPrimaryColor(scheme),
              width: 2,
            ),
          ),
        ),
        cardTheme: material.CardThemeData(
          color: material.Colors.grey[900],
          elevation: 2,
          shape: material.RoundedRectangleBorder(
            borderRadius: material.BorderRadius.circular(16),
          ),
        ),
      );
    }
    // Light mode (default)
    return material.ThemeData(
      useMaterial3: true,
      colorScheme: material.ColorScheme.light(
        primary: AppColors.getPrimaryColor(scheme),
        secondary: AppColors.getButtonPrimaryColor(scheme),
        surface: AppColors.surface,
        onPrimary: material.Colors.white,
        onSecondary: material.Colors.white,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
      ),
      appBarTheme: material.AppBarTheme(
        backgroundColor: AppColors.getPrimaryColor(scheme),
        foregroundColor: material.Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: material.ElevatedButtonThemeData(
        style: material.ElevatedButton.styleFrom(
          backgroundColor: AppColors.getButtonPrimaryColor(scheme),
          foregroundColor: material.Colors.white,
          shape: material.RoundedRectangleBorder(
            borderRadius: material.BorderRadius.circular(12),
          ),
          padding: const material.EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 24,
          ),
        ),
      ),
      floatingActionButtonTheme: material.FloatingActionButtonThemeData(
        backgroundColor: AppColors.getButtonPrimaryColor(scheme),
        foregroundColor: material.Colors.white,
      ),
      textTheme: const material.TextTheme(
        headlineLarge: material.TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: material.FontWeight.bold,
        ),
        headlineMedium: material.TextStyle(
          color: AppColors.textPrimary,
          fontSize: 28,
          fontWeight: material.FontWeight.w600,
        ),
        bodyLarge: material.TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: material.TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: material.InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: material.OutlineInputBorder(
          borderRadius: material.BorderRadius.circular(12),
          borderSide: material.BorderSide(color: AppColors.textSecondary),
        ),
        focusedBorder: material.OutlineInputBorder(
          borderRadius: material.BorderRadius.circular(12),
          borderSide: material.BorderSide(
            color: AppColors.getButtonPrimaryColor(scheme),
            width: 2,
          ),
        ),
      ),
      cardTheme: material.CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shape: material.RoundedRectangleBorder(
          borderRadius: material.BorderRadius.circular(16),
        ),
      ),
    );
  }

  // Helper getters for easy access
  material.Color get primaryColor =>
      AppColors.getPrimaryColor(currentColorScheme.value);
  material.Color get buttonPrimaryColor =>
      AppColors.getButtonPrimaryColor(currentColorScheme.value);
  material.Color get lightColor =>
      AppColors.getLightColor(currentColorScheme.value);
  material.Color get darkColor =>
      AppColors.getDarkColor(currentColorScheme.value);
  material.LinearGradient get gradient =>
      AppColors.getGradient(currentColorScheme.value);
}
