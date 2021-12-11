import 'package:flutter/material.dart';

/// ----  Green Theme  ----
const myColorLighter = Color(0xFFFFE19D);
const myColorLight = Color(0xFFFFCD59);
const myColorPrimary = Color(0xFF70BA71);
const myColorAccent = Color(0xFF336633);
const myColorBackground = Color(0xFFFFFFFF);
const myColorText = Color(0xFF000000);

final ThemeData base = ThemeData.light();

ThemeData myTheme = ThemeData.light().copyWith(
  primaryColor: myColorPrimary,
  primaryColorDark: myColorAccent,
  primaryColorLight: myColorLighter,
  primaryColorBrightness: Brightness.dark,
  errorColor: const Color(0xFFcc0000),
  colorScheme: base.colorScheme.copyWith(
      primary: myColorPrimary,
      secondary: myColorAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      surface: myColorLight,
      onSurface: Colors.black,
      primaryVariant: myColorPrimary,
      secondaryVariant: myColorAccent,
      background: myColorBackground,
      onBackground: Colors.black,
      error: const Color(0xFFcc0000),
      onError: Colors.white),
  buttonTheme: base.buttonTheme.copyWith(
    buttonColor: myColorAccent,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style:
        ButtonStyle(backgroundColor: MaterialStateProperty.all(myColorAccent)),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
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
          border: const Border(
              bottom: BorderSide(color: myColorAccent, width: 3)))),
  scaffoldBackgroundColor: myColorBackground,
  cardColor: myColorBackground,
  //textSelectionColor: PrimaryColorLight,
  backgroundColor: myColorBackground,
  textTheme: base.textTheme.copyWith(
      headline1: base.textTheme.headline1?.copyWith(color: myColorText),
      headline6: base.textTheme.headline6?.copyWith(color: myColorText),
      bodyText2: base.textTheme.bodyText2?.copyWith(color: myColorText)),
);
