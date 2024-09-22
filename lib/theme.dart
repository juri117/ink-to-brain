import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

// CONFIG

String logoAssetPath = "assets/icon/fling.png";
//String logoAssetPath = "assets/icon/icon_w.png";

bool useDarkTheme = false;

ThemeMode themeMode = (useDarkTheme) ? ThemeMode.dark : ThemeMode.light;

Color primary = const Color(0xFF70BA71);
Color primaryContainer = const Color(0xFFFFCD59);
Color secondary = const Color(0xFF336633);
Color secondaryContainer = const Color(0xFFFFE19D);
Color tertiary = const Color(0xFF000000);
Color tertiaryContainer = const Color(0xFFFFFFFF);

Color darkPrimary = const Color(0xffC484FF);
Color darkPrimaryContainer = const Color(0xFF373737);
Color darkSecondary = const Color(0xFF00DEC0);
Color darkSecondaryContainer = const Color(0xFF252525);
Color darkTertiary = const Color(0xFFFFB97D);
Color darkTertiaryContainer = const Color(0xFF505050);

const errorColor = Color(0xFFc21313);
const successColor = Color(0xFF13c213);

Color get colorPrimary {
  return (themeMode == ThemeMode.light) ? primary : darkPrimary;
}

Color get colorSecondary {
  return (themeMode == ThemeMode.light) ? secondary : darkSecondary;
}

Color get colorTertiary {
  return (themeMode == ThemeMode.light) ? tertiary : darkTertiary;
}

Color get colorTertiaryContainer {
  return (themeMode == ThemeMode.light)
      ? tertiaryContainer
      : darkTertiaryContainer;
}

Color get primaryTextColor {
  return (themeMode == ThemeMode.light) ? Colors.black : Colors.white;
}

FlexSchemeData myFlexScheme = FlexSchemeData(
  name: 'Midnight blue',
  description: 'Midnight blue theme, custom definition of all colors',
  light: FlexSchemeColor(
    primary: primary,
    primaryContainer: primaryContainer,
    secondary: secondary,
    secondaryContainer: secondaryContainer,
    tertiary: tertiary,
    tertiaryContainer: tertiaryContainer,
  ),
  dark: FlexSchemeColor(
    primary: darkPrimary,
    primaryContainer: darkPrimaryContainer,
    secondary: darkSecondary,
    secondaryContainer: darkSecondaryContainer,
    tertiary: darkTertiary,
    tertiaryContainer: darkTertiaryContainer,
  ),
);

BoxDecoration getInfoBoxDecorator(BuildContext context) {
  return BoxDecoration(
      // color: Theme.of(context).backgroundColor,
      color: Theme.of(context).colorScheme.primaryContainer,
      border:
          Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5),
      borderRadius: const BorderRadius.all(Radius.circular(3)));
}
