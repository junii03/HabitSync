import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade200,  // Clean white surface
    onSurface: Colors.blueGrey.shade700,  // Darker grey for readability
    primary: Colors.teal.shade100,  // Soft minty teal as the primary color
    onPrimary: Colors.teal.shade800,
    secondary: Colors.teal.shade50,  // Very light minty teal for secondary elements
    tertiary: Colors.grey.shade200,  // Very light grey for highlights
    inversePrimary: Colors.teal.shade200, // Slightly darker minty teal for inverted elements
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.grey.shade600),  // Darker grey for better readability
    bodyMedium: TextStyle(color: Colors.grey.shade600),  // Medium grey text
    headlineLarge: TextStyle(color: Colors.grey.shade700),  // Soft minty teal for headlines
  ),
);
