import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized theme definition for the TimberGuard app.
class AppTheme {
  AppTheme._();

  // Color constants

  static const Color forestGreen = Color(0xFF2D5A27);
  static const Color forestGreenLight = Color(0xFF4A7C43);
  static const Color forestGreenDark = Color(0xFF1A3A15);
  static const Color forestGreenSurface = Color(0xFFE8F2E6);

  static const Color slateGrey = Color(0xFF4A5568);
  static const Color slateGreyLight = Color(0xFF718096);
  static const Color slateGreyMuted = Color(0xFFA0AEC0);

  static const Color earthBrown = Color(0xFF8B5E3C);
  static const Color earthBrownLight = Color(0xFFB8845A);

  static const Color cream = Color(0xFFF7F4EF);
  static const Color offWhite = Color(0xFFFAF8F5);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2D9CF);

  static const Color darkText = Color(0xFF1A202C);
  static const Color successGreen = Color(0xFF276749);
  static const Color warningAmber = Color(0xFFB7791F);

  // Theme

  static ThemeData get light {
    // fromSeed generates a complete Material 3 palette; we override brand colors.
    final colorScheme = ColorScheme.fromSeed(
        seedColor: forestGreen,
        brightness: Brightness.light
    ).copyWith(
      primary: forestGreen,
      onPrimary: Colors.white,
      primaryContainer: forestGreenSurface,
      onPrimaryContainer: forestGreenDark,
      secondary: earthBrown,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFF5EBE0),
      onSecondaryContainer: const Color(0xFF5C3B1E),
      tertiary: slateGrey,
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFE8ECF2),
      onTertiaryContainer: darkText,
      outline: lightBorder,
      outlineVariant: const Color(0xFFEDE8E3),
      inverseSurface: darkText,
      onInverseSurface: offWhite,
      inversePrimary: forestGreenLight
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: cream
    );

    return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      sliderTheme: _sliderTheme(),
      switchTheme: _switchTheme(),
      inputDecorationTheme: _inputDecorationTheme(),
      dropdownMenuTheme: _dropdownMenuTheme(),
      cardTheme: _cardTheme(),
      dividerTheme: const DividerThemeData(color: lightBorder, thickness: 1)
    );
  }

  // Sub-theme

  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.interTextTheme(base).copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: offWhite,
        letterSpacing: -0.5
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: darkText,
        letterSpacing: -0.5
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: darkText
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: darkText
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: darkText
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: darkText
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: slateGrey,
        height: 1.6
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: slateGrey,
        height: 1.5
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        color: slateGrey,
        height: 1.5
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: darkText,
        letterSpacing: 0.1
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: slateGrey,
        letterSpacing: 0.5
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: slateGreyLight,
        letterSpacing: 0.5
      )
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: forestGreen,
        foregroundColor: Colors.white,
        disabledBackgroundColor: slateGreyMuted,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)
      )
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: forestGreen,
        side: const BorderSide(color: forestGreen, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)
      )
    );
  }

  static SliderThemeData _sliderTheme() {
    return SliderThemeData(
      activeTrackColor: forestGreen,
      inactiveTrackColor: forestGreen.withValues(alpha: 0.2),
      thumbColor: forestGreen,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayColor: forestGreen.withValues(alpha: 0.12),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
      valueIndicatorColor: earthBrown,
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w600
      ),
      showValueIndicator: ShowValueIndicator.onDrag,
      trackHeight: 4
    );
  }

  static SwitchThemeData _switchTheme() {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        return Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected) ? forestGreen : slateGreyLight.withValues(alpha: 0.4);
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected) ? forestGreen : slateGreyLight;
      })
    );
  }

  static InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: cardWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: lightBorder)
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: lightBorder)
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: forestGreen, width: 2)
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade600)
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade600, width: 2)
      ),
      labelStyle: GoogleFonts.inter(color: slateGrey, fontSize: 14),
      hintStyle: GoogleFonts.inter(color: slateGreyMuted, fontSize: 14),
      errorStyle: GoogleFonts.inter(color: Colors.red.shade700, fontSize: 12)
    );
  }

  static DropdownMenuThemeData _dropdownMenuTheme() {
    return DropdownMenuThemeData(
      inputDecorationTheme: _inputDecorationTheme(),
      menuStyle: MenuStyle(
        backgroundColor: const WidgetStatePropertyAll(cardWhite),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
        ),
        elevation: const WidgetStatePropertyAll(4.0),
        shadowColor: WidgetStatePropertyAll(Colors.black.withValues(alpha: 0.1))
      )
    );
  }

  static CardThemeData _cardTheme() {
    return CardThemeData(
      color: cardWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: lightBorder)
      ),
      clipBehavior: Clip.antiAlias
    );
  }
}