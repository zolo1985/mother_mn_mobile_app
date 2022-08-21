import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color darkGrey = Color(0xFF222222);
  static const Color black = Color(0xFF141414);
  static const Color primaryPinkInRGB = Color.fromARGB(255, 255, 80, 150);

  static const array = ["FF477E", "FF5C8A", "FF7096", "FF85A1", "FF99AC", "FBB1BD", "F9BEC7", "F7CAD0", "FAE0E4", "F7CAD0", "F9BEC7", "FBB1BD", "FF99AC", "FF85A1", "FF7096", "FF5C8A", "FF477E", "FF477E", "FF5C8A", "FF7096", "FF85A1", "FF99AC", "FBB1BD", "F9BEC7", "F7CAD0", "FAE0E4", "F7CAD0", "F9BEC7", "FBB1BD", "FF99AC", "FF85A1", "FF7096", "FF5C8A", "FF477E", "FF477E", "FF5C8A", "FF7096", "FF85A1", "FF99AC", "FBB1BD", "F9BEC7", "F7CAD0", "FAE0E4", "F7CAD0", "F9BEC7", "FBB1BD", "FF99AC", "FF85A1", "FF7096", "FF5C8A", "FF477E"];
  

  static const Color _iconColorLight = Colors.black;
  static const Color _iconColorDark = Colors.white;


  static const Color _lightPrimaryColor = Colors.white;
  static const Color _lightPrimaryVariantColor = Colors.white12;
  // static const Color _lightSecondaryColor = Colors.red;
  static const Color _lightOnPrimaryColor = Colors.black;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    backgroundColor: _lightPrimaryColor,
    scaffoldBackgroundColor: _lightPrimaryColor,
    primaryColor: Colors.white,
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
          color: _lightOnPrimaryColor,
          fontFamily: "Roboto",
          fontWeight: FontWeight.bold,
          fontSize: 26),
      iconTheme: IconThemeData(color: primaryPinkInRGB),
    ),
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppTheme.primaryPinkInRGB,
        selectionHandleColor: AppTheme.primaryPinkInRGB,
        selectionColor: AppTheme.primaryPinkInRGB),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(
        fontSize: 12,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: _lightPrimaryColor,
      primaryContainer: _lightPrimaryVariantColor,
      secondary: primaryPinkInRGB,
      onPrimary: _lightOnPrimaryColor,
    ),
    iconTheme: const IconThemeData(
      color: _iconColorLight,
    ),
    textTheme: _lightTextTheme,
    tabBarTheme: const TabBarTheme(
        labelColor: Colors.black,
        indicator: ShapeDecoration(
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: primaryPinkInRGB, width: 3)),
        )),
    dividerTheme: const DividerThemeData(color: Colors.black12),
    // sliderTheme: SliderThemeData(
    // ),
  );

  static const Color _darkPrimaryColor = Colors.black;
  static const Color _darkPrimaryVariantColor = Colors.white12;
  static const Color _darkSecondaryColor = Colors.red;
  static const Color _darkOnPrimaryColor = Colors.white;

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
      backgroundColor: _darkPrimaryColor,
      scaffoldBackgroundColor: _darkPrimaryColor,
      unselectedWidgetColor: Colors.grey,
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
            color: _darkOnPrimaryColor,
            fontFamily: "Roboto",
            fontWeight: FontWeight.bold,
            fontSize: 26),
        color: _darkPrimaryColor,
        iconTheme: IconThemeData(color: primaryPinkInRGB),
      ),
      textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppTheme.primaryPinkInRGB,
          selectionHandleColor: AppTheme.primaryPinkInRGB,
          selectionColor: AppTheme.primaryPinkInRGB),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          fontSize: 12,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimaryColor,
        primaryContainer: _darkPrimaryVariantColor,
        secondary: _darkSecondaryColor,
        onPrimary: _darkOnPrimaryColor,
      ),
      iconTheme: const IconThemeData(
        color: _iconColorDark,
      ),
      textTheme: _darkTextTheme,
      tabBarTheme: const TabBarTheme(
          indicator: ShapeDecoration(
        shape: UnderlineInputBorder(
            borderSide: BorderSide(
                color: primaryPinkInRGB, width: 3)),
      )),
      dividerTheme: const DividerThemeData(color: Colors.black12));

  static const TextTheme _lightTextTheme = TextTheme(
      headline1: _lightScreenHeading1TextStyle,
      bodyText1: _lightScreenBodyText1TextStyle,
      bodyText2: _lightScreenBodyText1TextStyle);

  static final TextTheme _darkTextTheme = TextTheme(
      headline1: _darkScreenHeading1TextStyle,
      bodyText1: _darkScreenBodyText1TextStyle,
      bodyText2: _darkScreenBodyText1TextStyle);

  static const TextStyle _lightScreenHeading1TextStyle = TextStyle(
      fontSize: 26.0,
      fontWeight: FontWeight.bold,
      color: _lightOnPrimaryColor,
      fontFamily: "Roboto");

  static final TextStyle _darkScreenHeading1TextStyle =
      _lightScreenHeading1TextStyle.copyWith(color: _darkOnPrimaryColor);

  static const TextStyle _lightScreenBodyText1TextStyle = TextStyle(color: _lightOnPrimaryColor, fontFamily: "Roboto");

  static const TextStyle _darkScreenBodyText1TextStyle = TextStyle(color: _darkOnPrimaryColor, fontFamily: "Roboto");
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
