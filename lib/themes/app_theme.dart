import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The [AppTheme] defines light and dark themes for the app, mimicking WhatsApp's colors.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade package to version 8.1.0.
///
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///   ...
/// );
abstract final class AppTheme {
  // The defined light theme, emphasizing WhatsApp's signature green.
  static ThemeData light = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: Color.fromARGB(255, 7, 218, 193), // WhatsApp's distinct, rich green.
      primaryContainer: Color.fromARGB(255, 101, 202, 23), // Light, almost pastel green background.
      primaryLightRef: Color.fromARGB(255, 6, 165, 233), // A vibrant blue, for links or highlights.
      secondary: Color.fromARGB(255, 10, 226, 89), // A bright, lively lime green accent.
      secondaryContainer: Color.fromARGB(255, 232, 241, 233), // Very light mint green background.
      secondaryLightRef: Color.fromARGB(255, 5, 236, 90),
      tertiary: Color.fromARGB(255, 9, 187, 166), // A deeper, teal-leaning green for emphasis.
      tertiaryContainer: Color(0xFFB2DFDB), // Soft, light turquoise background.
      tertiaryLightRef: Color.fromARGB(255, 6, 226, 201),
      appBarColor: Color(0xFF075E54), // The signature green for the app bar.
      error: Color.fromARGB(255, 236, 0, 44), // Standard error red.
      errorContainer: Color(0xFFCF6679), // Light rose red error background.
    ),
    subThemesData: const FlexSubThemesData(
      inputDecoratorIsFilled: true,
      alignedDropdown: true,
      tooltipRadius: 4,
      tooltipSchemeColor: SchemeColor.inverseSurface,
      tooltipOpacity: 0.9,
      snackBarElevation: 6,
      snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
      useError: true,
      keepPrimary: true,
      keepSecondary: true,
      keepTertiary: true,
    ),
    tones: FlexSchemeVariant.material.tones(Brightness.light), // Using material tones.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The defined dark theme, emphasizing WhatsApp's signature green in dark mode.
  static ThemeData dark = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: Color(0xFF128C7E), // A deep teal-green, WhatsApp's dark mode primary.
      primaryContainer: Color(0xFF1E2429), // Dark charcoal gray background.
      primaryLightRef: Color(0xFF34B7F1), // The same vibrant blue.
      secondary: Color(0xFF25D366), // Bright lime green accent.
      secondaryContainer: Color(0xFF2A3942), // Dark slate blue-gray background.
      secondaryLightRef: Color(0xFF25D366),
      tertiary: Color(0xFF075E54), // The signature green, lighter in dark mode context.
      tertiaryContainer: Color(0xFF37474F), // Dark, cool gray background.
      tertiaryLightRef: Color(0xFF075E54),
      appBarColor: Color(0xFF128C7E), // Deep teal for the dark mode app bar.
      error: Color(0xFFCF6679), // Light rose red error.
      errorContainer: Color(0xFFB00020), // Standard error red.
    ),
    subThemesData: const FlexSubThemesData(
      blendOnColors: true,
      inputDecoratorIsFilled: true,
      alignedDropdown: true,
      tooltipRadius: 4,
      tooltipSchemeColor: SchemeColor.inverseSurface,
      tooltipOpacity: 0.9,
      snackBarElevation: 6,
      snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
      useError: true,
    ),
    tones: FlexSchemeVariant.material.tones(Brightness.dark), // Using material tones.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}