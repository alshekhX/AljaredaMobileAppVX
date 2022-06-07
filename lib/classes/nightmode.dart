import 'dart:ui';

import 'package:flutter/material.dart';

class Stylesss {
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
       textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF174378),
          selectionColor: Color(0xFF174378).withOpacity(.4),
          selectionHandleColor: Color(0xFF174378)
        ),
      primarySwatch: createMaterialColor(Colors.white),
      primaryColor: isDarkTheme ? Colors.blueGrey.shade800 : Colors.white,
      backgroundColor: isDarkTheme
          ? createMaterialColor(Color(0xFF174378)).shade600
          : Color(0xffF1F5FB),
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xff0E1D36) ,
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Colors.grey : Color(0xffEECED3),
      highlightColor: isDarkTheme ? Colors.blueGrey :Colors.lightBlue ,
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme ? Colors.grey : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      cardColor: isDarkTheme ?Color.fromARGB(255, 55, 71, 79) : Colors.white,
      fontFamily: 'Almari',
      canvasColor: isDarkTheme ? Color(0xFF263238) : Colors.white,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 4.0,
        
      ),
    );
  }
}
