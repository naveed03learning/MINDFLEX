import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFF0E0E11);
  static const surface = Color(0xFF0E0E11);
  static const surfaceContainer = Color(0xFF19191D);
  static const surfaceContainerHigh = Color(0xFF1F1F23);
  static const surfaceContainerHighest = Color(0xFF25252A);
  static const surfaceContainerLow = Color(0xFF131316);
  static const surfaceContainerLowest = Color(0xFF000000);
  static const surfaceBright = Color(0xFF2C2C30);
  static const surfaceVariant = Color(0xFF25252A);

  static const primary = Color(0xFFFF8D8E);
  static const primaryDim = Color(0xFFDE2B41);
  static const primaryFixed = Color(0xFFFF7579);
  static const primaryFixedDim = Color(0xFFFF5963);

  static const secondary = Color(0xFFFE81A3);
  static const secondaryContainer = Color(0xFF832042);

  static const tertiary = Color(0xFFC9A1FF);
  static const tertiaryContainer = Color(0xFFBE90FD);

  static const onBackground = Color(0xFFFBF8FC);
  static const onSurface = Color(0xFFFBF8FC);
  static const onSurfaceVariant = Color(0xFFACAAAE);
  static const onPrimary = Color(0xFF640012);
  static const onPrimaryFixed = Color(0xFF000000);

  static const outline = Color(0xFF767578);
  static const outlineVariant = Color(0xFF48474B);

  static const error = Color(0xFFFF7351);
  static const errorDim = Color(0xFFD53D18);

  static const correct = Color(0xFF22C55E);
  static const wrong = Color(0xFFEF4444);
  static const orange = Color(0xFFFB923C);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        background: AppColors.background,
        surface: AppColors.surface,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        onBackground: AppColors.onBackground,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.manrope(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.manrope(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.manrope(
          color: AppColors.onSurfaceVariant,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.manrope(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.manrope(
          color: AppColors.onSurfaceVariant,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
