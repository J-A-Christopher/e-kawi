import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/// The [AppTheme] defines light and dark themes for the app.
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
///     :
/// );
abstract final class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
  colors: const FlexSchemeColor( // Custom colors
    primary: Color(0xFF1A237E),
    primaryContainer: Color(0xFFFFB300),
    primaryLightRef: Color(0xFF1A237E),
    secondary: Color(0xFFFFC107),
    secondaryContainer: Color(0xFFFFDBCF),
    secondaryLightRef: Color(0xFFFFC107),
    tertiary: Color(0xFF00BCD4),
    tertiaryContainer: Color(0xFF95F0FF),
    tertiaryLightRef: Color(0xFF00BCD4),
    appBarColor: Color(0xFFFFDBCF),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
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
  tones: FlexSchemeVariant.jolly.tones(Brightness.light),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
  colors: const FlexSchemeColor( // Custom colors
    primary: Color(0xFF1A237E),
    primaryContainer: Color(0xFF00325B),
    primaryLightRef: Color(0xFF1A237E),
    secondary: Color(0xFF00C107),
    secondaryContainer: Color(0xFF872100),
    secondaryLightRef: Color(0xFFFFC107),
    tertiary: Color(0xFF00BCD4),
    tertiaryContainer: Color(0xFF455A64),
    tertiaryLightRef: Color(0xFF00BCD4),
    appBarColor: Color(0xFFFFDBCF),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
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
  tones: FlexSchemeVariant.jolly.tones(Brightness.dark),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
