import 'package:shopcare/src/util/theme/widget_theme/text_field_theme.dart';
import 'package:shopcare/src/util/theme/widget_theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'elevate_button_theme.dart';
import 'outlined_button_theme.dart';


class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: TTextTheme.lightTextTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: TElevatedButton.lightElevatedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    //scaffoldBackgroundColor: Colors.cyanAccent
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: TTextTheme.lightTextTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: TElevatedButton.lightElevatedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    //scaffoldBackgroundColor: Colors.cyanAccen
  );
}
