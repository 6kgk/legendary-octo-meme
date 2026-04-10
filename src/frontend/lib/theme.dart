import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Aesthetic 3.0 Design Tokens
class AppColors {
  static const Color mainText = Color(0xFF1A1A1A);
  static const Color subText = Color(0xFF999999);
  static const Color weakText = Color(0xFFCCCCCC);
  static const Color background = Color(0xFFFFFFFF);
  static const Color areaBg = Color(0xFFF5F5F3);
  static const Color divider = Color(0xFFF0F0F0);
  
  // Highlight colors for specific actions
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color primaryYellow = Color(0xFFFFD541);
}

class AppTheme {
  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.mainText,
        primary: AppColors.mainText,
        onPrimary: AppColors.background,
        background: AppColors.background,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 0.5,
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.mainText,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.mainText,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          height: 1.6,
          color: AppColors.mainText,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 13,
          color: AppColors.subText,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.mainText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppColors.mainText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainText,
          foregroundColor: AppColors.background,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Using 0.5px borders instead of rounded cards in Aesthetic 3.0
          side: const BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
    );
  }
}
