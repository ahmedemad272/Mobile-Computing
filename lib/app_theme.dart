import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color background = Color(0xFFF0F0F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFF5C5CE0);
  static const Color danger = Color(0xFFE05252);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textMuted = Color(0xFF9E9E9E);
  static const Color iconGrey = Color(0xFF757575);

  // Border radius
  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double inputRadius = 12.0;

  // Card decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // Text styles
  static TextStyle get titleStyle => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      );

  static TextStyle get todoTextStyle => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      );

  static TextStyle get todoCompletedTextStyle => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: textMuted,
        decoration: TextDecoration.lineThrough,
        decorationColor: textMuted,
      );

  static TextStyle get emptyStateTextStyle => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textMuted,
      );

  static TextStyle get hintTextStyle => GoogleFonts.poppins(
        fontSize: 14,
        color: textMuted,
      );

  // ThemeData
  static ThemeData get themeData => ThemeData(
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.light(
          primary: accent,
          secondary: accent,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: textPrimary),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return accent;
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: const BorderSide(color: accent, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
}
