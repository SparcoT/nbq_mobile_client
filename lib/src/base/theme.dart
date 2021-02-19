part of '../app.dart';

abstract class AppTheme {
  static const primaryColor = Color(0xFFDE007B);

  static final _light = ThemeData(
    primaryColor: primaryColor,
    accentColor: primaryColor,

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: GoogleFonts.bebasNeue(
          fontSize: 18,
          fontWeight: FontWeight.bold
        )
      )
    )
  );
}