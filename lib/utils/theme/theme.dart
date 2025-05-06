import 'package:flutter/material.dart';

// Existing color constants.
const Color white = Colors.white;
const Color black = Colors.black;
const Color bgColor = white;
const Color buttonColor = Color(0xFF0e8673);
const Color bottomNavBackColor = Color(0xFF0e8673);
const Color bottomNavIconBackColor = Color(0xFFF4FFC3);
const Color appBarBackgroundColor = Color(0xFF0e8673);
const Color snackbarColor = Color(0xFFA9C46C);
const Color tileColor = Color(0xFF0e8673);
const Color circleAvatarbgColor = white;
// Define the light theme.
final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: buttonColor,
    scaffoldBackgroundColor: bgColor,
    appBarTheme: AppBarTheme(
      backgroundColor: appBarBackgroundColor,
      iconTheme: IconThemeData(color: black),
      titleTextStyle: TextStyle(
        color: black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: bottomNavBackColor,
      selectedItemColor: bottomNavIconBackColor,
      unselectedItemColor: black,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: snackbarColor,
      contentTextStyle: TextStyle(color: white),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: black),
      displayMedium: TextStyle(color: black),
      displaySmall: TextStyle(color: black),
      headlineMedium: TextStyle(color: black),
      headlineSmall: TextStyle(color: black),
      titleLarge: TextStyle(color: black),
      bodyLarge: TextStyle(color: black),
      bodyMedium: TextStyle(color: black),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: buttonColor,
      foregroundColor: white,
    ),
    iconTheme: IconThemeData(color: black));

// Define the dark theme.
final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: buttonColor,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: white),
      titleTextStyle: TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: bottomNavIconBackColor,
      unselectedItemColor: white,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: snackbarColor,
      // Invert the text color so it stands out on the light snackbar background.
      contentTextStyle: TextStyle(color: black),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: white),
      displayMedium: TextStyle(color: white),
      displaySmall: TextStyle(color: white),
      headlineMedium: TextStyle(color: white),
      headlineSmall: TextStyle(color: white),
      titleLarge: TextStyle(color: white),
      bodyLarge: TextStyle(color: white),
      bodyMedium: TextStyle(color: white),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: buttonColor,
      foregroundColor: white,
    ),
    iconTheme: IconThemeData(color: white));
