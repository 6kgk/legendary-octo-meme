import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // 主色调
  static const Color primary = Color(0xFF6C63FF); // 紫蓝主色
  static const Color primaryLight = Color(0xFFEEECFF);
  static const Color secondary = Color(0xFF00BFA6); // 薄荷绿
  static const Color secondaryLight = Color(0xFFE0F7F3);
  static const Color accent = Color(0xFFFF6B6B); // 珊瑚红（错误/收藏）
  static const Color warning = Color(0xFFFFB74D); // 暖橙
  
  // 文字
  static const Color mainText = Color(0xFF1E1E2C);
  static const Color subText = Color(0xFF8F8FA3);
  static const Color weakText = Color(0xFFBDBDCF);
  
  // 背景
  static const Color background = Color(0xFFFAFAFC);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color areaBg = Color(0xFFF2F2F7);
  static const Color divider = Color(0xFFEEEEF2);

  // 渐变
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF4834DF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF00BFA6), Color(0xFF00897B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.background,
        error: AppColors.accent,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.mainText),
        headlineMedium: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.mainText),
        titleLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.mainText),
        bodyLarge: GoogleFonts.inter(fontSize: 15, height: 1.6, color: AppColors.mainText),
        bodyMedium: GoogleFonts.inter(fontSize: 13, color: AppColors.subText),
        labelSmall: GoogleFonts.inter(fontSize: 11, color: AppColors.weakText),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.mainText, fontSize: 20, fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: AppColors.mainText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.areaBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        hintStyle: GoogleFonts.inter(color: AppColors.weakText, fontSize: 14),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1),
    );
  }
}
