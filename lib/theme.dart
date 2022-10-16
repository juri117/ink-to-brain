import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

// CONFIG

String logoAssetPath = "assets/icon/fling.png";
//String logoAssetPath = "assets/icon/icon_w.png";

bool useDarkTheme = false;

ThemeMode themeMode = (useDarkTheme) ? ThemeMode.dark : ThemeMode.light;

Color primary = Color(0xFF70BA71);
Color primaryContainer = Color(0xFFFFCD59);
Color secondary = Color(0xFF336633);
Color secondaryContainer = Color(0xFFFFE19D);
Color tertiary = Color(0xFF000000);
Color tertiaryContainer = Color(0xFFFFFFFF);

Color darkPrimary = Color(0xffC484FF);
Color darkPrimaryContainer = Color(0xFF373737);
Color darkSecondary = Color(0xFF00DEC0);
Color darkSecondaryContainer = Color(0xFF252525);
Color darkTertiary = Color(0xFFFFB97D);
Color darkTertiaryContainer = Color(0xFF505050);

final errorColor = Color(0xFFc21313);
final successColor = Color(0xFF13c213);

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
      borderRadius: BorderRadius.all(Radius.circular(3)));
}


/// ----  Labfly Theme  ----
/*
final colorLighter = Color(0xFF99FF99);
final colorLight = Color(0xFFA3CEF1);
final colorPrimary = Color(0xFF4A86E8);
final colorAccentHover = Color(0xFF385a82);
final colorAccent = Color(0xFF274C77);
final colorBackground = Color(0xFFE7ECEF);
final colorDivider = colorPrimary; //Color(0xFF8B8C89);
final colorCardBg = Color(0xFFFFFFFF);
final colorError = Color(0xFFc21313);



final myColorLighter = Color(0xFFE7ECEF);
final myColorLight = Color(0xFFA3CEF1);
final myColorPrimary = Color(0xFF4A86E8);
final myColorAccent = Color(0xFF274C77);
final myColorBackground = Color(0xFFFFFFFF);
final myColorText = Color(0xFF000000);
final myColorError = Color(0xFFc21313);

final ThemeData base = ThemeData.light();

ThemeData colorTheme = ThemeData.light().copyWith(
  //accentColor: myColorAccent,
  //accentColorBrightness: Brightness.dark,
  primaryColor: myColorPrimary,
  primaryColorDark: myColorAccent,
  primaryColorLight: myColorLight,
  //primaryColorBrightness: Brightness.dark,
  errorColor: Color(0xFFcc0000),
  colorScheme: base.colorScheme.copyWith(
      primary: myColorPrimary,
      secondary: myColorAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      surface: myColorLight,
      onSurface: Colors.black,
      //primaryVariant: myColorLight,
      //secondaryVariant: myColorLighter,
      secondaryContainer: myColorLighter,
      background: myColorBackground,
      onBackground: Colors.black,
      error: myColorError,
      onError: Colors.white),
  buttonTheme: base.buttonTheme.copyWith(
    buttonColor: myColorAccent,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style:
        ButtonStyle(backgroundColor: MaterialStateProperty.all(myColorAccent)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: myColorAccent, foregroundColor: Colors.white),
  radioTheme:
      RadioThemeData(fillColor: MaterialStateProperty.all(myColorPrimary)),
  checkboxTheme:
      CheckboxThemeData(fillColor: MaterialStateProperty.all(myColorPrimary)),
  tabBarTheme: TabBarTheme(
      //unselectedLabelColor: Colors.white.withOpacity(0.5),
      //labelColor: Colors.white,

      indicator: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          border: Border(bottom: BorderSide(color: myColorAccent, width: 3)))),
  scaffoldBackgroundColor: myColorBackground,
  cardColor: myColorBackground,
  //textSelectionColor: PrimaryColorLight,
  backgroundColor: myColorBackground,
  textTheme: base.textTheme.copyWith(
      headline1: base.textTheme.headline1?.copyWith(color: myColorText),
      headline6: base.textTheme.headline6?.copyWith(color: myColorText),
      bodyText2: base.textTheme.bodyText2?.copyWith(color: myColorText)),
);

*/


/*
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
  */
