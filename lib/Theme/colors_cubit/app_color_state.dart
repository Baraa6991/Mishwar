import 'package:flutter/material.dart';

class ThemeState {
  bool isDarkMode;
  final Color primary;
  final Color secondary;
  final Color black;
  final Color white;
  final Color amber;
  final Color green;
  ThemeState({
    required this.isDarkMode,
    required this.primary,
    required this.secondary,
    required this.black,
    required this.white,
    required this.amber,
    required this.green,
  });

  factory ThemeState.light() {
    return ThemeState(
      isDarkMode: false,
      primary: const Color(0xFFBCD4CC),
      secondary: const Color(0xFF001839),
      black: const Color(0xFF000000),
      white: const Color(0xFFFFFFFF),
      amber: const Color(0xFFFFC107),
      green: const Color(0xFF4CAF50),
    );
  }
  factory ThemeState.dark() {
    return ThemeState(
      isDarkMode: true,
      primary: const Color(0xFF001839),
      secondary: const Color(0xFFBCD4CC),
      black: const Color(0xFFFFFFFF),
      white: const Color(0xFF000000),
      amber: const Color(0xFFFFC107),
      green: const Color(0xFF4CAF50),
    );
  }
}
