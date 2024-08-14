import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,  // Darker surface for better contrast
    onSurface: Colors.blueGrey.shade300,  // Lighter blue-grey for readability
    primary: Colors.teal.shade600,  // Teal for primary color
    onPrimary: Colors.teal.shade100,  // Lighter teal for text on primary color
    secondary: Colors.teal.shade800,  // Darker teal for secondary elements
    tertiary: Colors.blueGrey.shade700,  // Dark blue-grey for highlights
    inversePrimary: Colors.teal.shade300, // Lighter teal for inverted elements
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.grey.shade600),  // Softer text color for readability
    bodyMedium: TextStyle(color: Colors.grey.shade400),  // Medium text color
    headlineLarge: TextStyle(color: Colors.grey.shade400),  // Lighter teal for headlines
  ),
);
