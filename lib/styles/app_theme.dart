import 'package:flutter/material.dart';

import 'layout.dart';

class AppTheme {
  static ThemeData lightTheme(ColorScheme? lightColorScheme) {
    ColorScheme scheme = lightColorScheme ??
        ColorScheme.fromSeed(
          seedColor: Colors.green,
        );
    return ThemeData(
      colorScheme: scheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Layout.RADIUS * 1.5),
          ),
        ),
      ),
      cardTheme: const CardTheme(
        elevation: Layout.ELEVATION,
      ),
    );
  }

  static ThemeData darkTheme(ColorScheme? darkColorScheme) {
    ColorScheme scheme = darkColorScheme ??
        ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        );
    return ThemeData(
      colorScheme: scheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Layout.RADIUS * 1.5),
          ),
        ),
      ),
      cardTheme: const CardTheme(
        elevation: Layout.ELEVATION,
      ),
    );
  }
}
