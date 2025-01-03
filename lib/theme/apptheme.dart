import 'package:flutter/material.dart';

const ColorScheme colorPalette = ColorScheme(
  primary: Color(0xFF4DC3FF),
  primaryContainer: Color(0xFFF2F1EC),
  secondary: Color(0xFF2C6CF5),
  secondaryContainer: Color(0xFFFFFFFF),
  surface: Color(0xFFF2F1EC),
  surfaceBright: Color(0xFFD9D9D9),
  surfaceContainer: Color(0xFFB2B2B2),
  error: Color(0xFFF94143),
  onPrimary: Color(0xFF464646),
  onSecondary: Color(0xFFFFFFFF),
  onSurface: Color(0xFF1F1F1F),
  onError: Color(0xFFFFFFFF),
  brightness: Brightness.light,
);

final ThemeData appTheme = ThemeData(
  fontFamily: "Poppins",
  dividerColor: Colors.transparent,
  colorScheme: colorPalette,
  primaryColor: colorPalette.primary,
  scaffoldBackgroundColor: colorPalette.surface,
  indicatorColor: colorPalette.surfaceContainer,
  splashColor: colorPalette.surfaceContainer,
  highlightColor: colorPalette.surfaceContainer,
  appBarTheme: AppBarTheme(
    backgroundColor: colorPalette.surface,
    foregroundColor: colorPalette.onSurface,
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      height: 1,
      color: colorPalette.onSurface,
      fontSize: 40,
      fontWeight: FontWeight.w800,
    ),
    displaySmall: TextStyle(
      color: colorPalette.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: TextStyle(
      color: colorPalette.onSurface,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      color: colorPalette.onSurface,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      color: colorPalette.secondaryContainer,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: colorPalette.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: colorPalette.primary,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: colorPalette.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      color: colorPalette.secondaryContainer,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    bodyMedium: TextStyle(
      color: colorPalette.onPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    bodySmall: TextStyle(
      color: colorPalette.surfaceBright,
      fontSize: 14,
    ),
    labelLarge: TextStyle(
      color: colorPalette.onSecondary,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: TextStyle(
      color: colorPalette.primary,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(
      color: colorPalette.secondaryContainer,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: colorPalette.surfaceContainer,
  ),
);
