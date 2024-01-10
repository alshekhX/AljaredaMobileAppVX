import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/settingProvider.dart';

class Stylesss {
//colors
  Color nightModeBackground = Colors.blueGrey.shade900;
  Color nightElement = Color(0xffd1bcff);
    Color darkNightElement = Color(0xff371e72);


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
          selectionHandleColor: Color(0xFF174378)),
      primaryColor: isDarkTheme ? Colors.blueGrey.shade800 : Colors.white,
      backgroundColor: isDarkTheme
          ? createMaterialColor(Color(0xFF174378)).shade600
          : Colors.white,
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xff0E1D36),
      // buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      highlightColor: isDarkTheme ? Colors.blueGrey : Colors.lightBlue,
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      cardColor: isDarkTheme ? Color.fromARGB(255, 55, 71, 79) : Colors.white,
      textTheme: GoogleFonts.rubikTextTheme().apply(
        bodyColor: Provider.of<Setting>(context, listen: false).nightmode!
            ? Colors.white.withOpacity(.87)
            : Colors.black.withOpacity(.87),
        displayColor: Provider.of<Setting>(context, listen: false).nightmode!
            ? Colors.white.withOpacity(.87)
            : Colors.black.withOpacity(.87),
      ),
      canvasColor: isDarkTheme ? Color(0xFF263238) : Colors.white,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'Almari',
              color: Provider.of<Setting>(context, listen: false).nightmode!
                  ? Colors.white.withOpacity(.87)
                  : Color(0xff212427),
              fontWeight: FontWeight.w600)),
    );
  }
}
