import 'package:flutter/material.dart';
import 'package:todo_list/extensions/color_scheme.dart';

class LightTheme {
  ThemeData get theme {
    return ThemeData.light().copyWith(
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.transparent,
        outlineBorder: BorderSide(
          color: Colors.grey.shade400.withAlpha(100),
          width: 1,
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppColorScheme(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.dark,
          groupBackgroundColor: const Color(0xfff5f5f5),
        ),
      ],
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade600,
      ),
    );
  }
}
