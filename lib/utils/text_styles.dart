// utils/text_styles.dart
import 'package:flutter/material.dart';

class AppTextStyles {


  // Bottom Navigation Bar TextStyle
  // Headers
  static const TextStyle headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // Body text
  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );

  // Buttons
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Customizable style with parameters
  static TextStyle customText({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
