part of '../app.dart';

abstract class AppTheme {
  static const primaryColor = Color(0xFFDE007B);

  static const colorOfFast = Color(0xFF096B73);
  static const colorOfPropulse = Color(0xFF0A060B);
  static const colorOfSlow = Color(0xFF553972);
  static const colorOfWTF = Color(0xFFCF7726);

  static final _light = ThemeData(
    primaryColor: primaryColor,
    accentColor: primaryColor,

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.bebasNeue()
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        textStyle: GoogleFonts.bebasNeue(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
