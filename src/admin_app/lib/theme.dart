import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFFEEECFF);
  static const Color success = Color(0xFF00BFA6);
  static const Color warning = Color(0xFFFFB74D);
  static const Color danger = Color(0xFFFF6B6B);
  static const Color mainText = Color(0xFF1E1E2C);
  static const Color subText = Color(0xFF8F8FA3);
  static const Color weakText = Color(0xFFBDBDCF);
  static const Color background = Color(0xFFF5F5FA);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFEEEEF2);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF4834DF)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
}

class AdminTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AdminColors.background,
      colorScheme: ColorScheme.fromSeed(seedColor: AdminColors.primary),
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: AdminColors.cardBg,
        elevation: 0, scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.inter(
          color: AdminColors.mainText, fontSize: 18, fontWeight: FontWeight.w700),
        iconTheme: const IconThemeData(color: AdminColors.mainText),
      ),
      cardTheme: CardTheme(
        color: AdminColors.cardBg, elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AdminColors.primary, foregroundColor: Colors.white,
          elevation: 0, minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
