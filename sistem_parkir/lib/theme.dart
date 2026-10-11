import 'package:flutter/material.dart';

/// Palet warna segar: hijau muda, putih, aksen laut, teks hitam jelas.
class AppColors {
  static const Color primaryGreen = Color(0xFF4CAF50); // hijau segar
  static const Color lightGreen = Color(0xFFE8F5E9); // hijau muda lembut
  static const Color mintGreen = Color(0xFFB9E4C9);
  static const Color ocean = Color(0xFF0288D1); // biru laut
  static const Color oceanLight = Color(0xFFB3E5FC); // laut muda
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF4FBF6); // putih kehijauan
  static const Color textDark = Color(0xFF1B1B1B);
  static const Color textMuted = Color(0xFF5F6B62);
  static const Color danger = Color(0xFFD32F2F);
}

ThemeData buildAppTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryGreen,
      primary: AppColors.primaryGreen,
      secondary: AppColors.ocean,
      surface: AppColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      centerTitle: false,
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
    ),
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.textDark,
      displayColor: AppColors.textDark,
    ),
  );
}
