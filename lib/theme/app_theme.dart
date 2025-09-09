
import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors
  static const Color buttonGreen    = Color(0xFF2D9C6F);
  static const Color accentTeal     = Color(0xFF00D6B4);
  static const Color accentTealDark = Color(0xFF00C2A1);

  /// Base Theme
  static ThemeData _base(ColorScheme cs, {required bool dark}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,

      scaffoldBackgroundColor: dark ? cs.background : cs.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: cs.onSurface),
        titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),

      cardColor: cs.surface,

      dividerTheme: DividerThemeData(
        color: cs.outline.withOpacity(dark ? .25 : .35),
        thickness: 1,
        space: 1,
      ),

      listTileTheme: ListTileThemeData(
        iconColor: cs.onSurface,
        textColor: cs.onSurface,
        tileColor: cs.surface,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF232327) : const Color(0xFFF2F3F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: cs.outline.withOpacity(.35)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: cs.outline.withOpacity(.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: cs.primary, width: 1.3),
        ),
      ),

      iconTheme: IconThemeData(color: cs.onSurface),
    );
  }

  /// Light theme 
  static final ThemeData light = _base(
    const ColorScheme.light(
      primary: buttonGreen,
      onPrimary: Colors.white,
      secondary: accentTeal,
      secondaryContainer: accentTealDark,
      onSecondary: Colors.white,
      background: Colors.white,        // keep background white
      onBackground: Color(0xFF303030),
      surface: Colors.white,           // app bar + cards
      onSurface: Color(0xFF202020),
      outline: Color(0xFFD6D6D6),
    ),
    dark: false,
  );

  /// Dark theme 
  static final ThemeData dark = _base(
    const ColorScheme.dark(
      primary: buttonGreen,
      onPrimary: Colors.white,
      secondary: accentTeal,
      secondaryContainer: accentTealDark,
      onSecondary: Colors.black,
      background: Color(0xFF121212),   // page background
      onBackground: Colors.white,
      surface: Color(0xFF1B1B1D),      // app bar / cards (a bit darker)
      onSurface: Color(0xFFEDEDED),
      outline: Color(0xFF3A3A3A),
    ),
    dark: true,
  );
}
