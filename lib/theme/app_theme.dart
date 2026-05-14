import 'package:flutter/material.dart';

class FlinkColors {
  static const Color pink = Color(0xFFFF375F);
  static const Color black = Color(0xFF1A1A1A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color midGrey = Color(0xFFE8E8E8);
  static const Color textGrey = Color(0xFF767676);
  static const Color darkGrey = Color(0xFF333333);
}

class FlinkTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: false,
        primaryColor: FlinkColors.pink,
        scaffoldBackgroundColor: FlinkColors.white,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: FlinkColors.white,
          foregroundColor: FlinkColors.black,
          elevation: 0.5,
          centerTitle: false,
          iconTheme: IconThemeData(color: FlinkColors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: FlinkColors.pink,
            foregroundColor: FlinkColors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: FlinkColors.lightGrey,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: FlinkColors.midGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: FlinkColors.midGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: FlinkColors.pink, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: FlinkColors.pink),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: FlinkColors.pink, width: 1.5),
          ),
          labelStyle:
              const TextStyle(color: FlinkColors.textGrey, fontSize: 15),
          errorStyle: const TextStyle(color: FlinkColors.pink),
        ),
      );
}