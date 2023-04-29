import 'package:flutter/material.dart';
import 'package:todo_list/extensions/color_scheme.dart';

class DarkTheme {
  ThemeData get theme {
    return ThemeData.dark().copyWith(
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.transparent,
        outlineBorder: BorderSide(
            color: Colors.grey.shade200.withAlpha(50),
            width: 1,
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppColorScheme(
            statusBarColor: const Color(0xff202020),
            statusBarBrightness: Brightness.light,
            groupBackgroundColor: const Color(0xff303030)),
      ],
      primaryColor: const Color(0xff1B9CFC),
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: Colors.grey.shade400,
        ),
        bodySmall: TextStyle(
          color: Colors.grey.shade200,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xff202020),
        foregroundColor: Colors.grey.shade300,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xff1B9CFC),
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: const Color(0xff1B9CFC),
        unselectedItemColor: Colors.grey.shade300,
        backgroundColor: const Color(0xff202020),
        elevation: 0,
      ),
      scaffoldBackgroundColor: const Color(0xff2a2a2a),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) => states.isNotEmpty
              ? const Color(0xff1B9CFC)
              : Colors.grey.shade400,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: MaterialStateProperty.resolveWith(
          (states) => states.isNotEmpty
              ? const Color(0xff1B9CFC)
              : Colors.grey.shade400,
        ),
        thumbColor: MaterialStateProperty.resolveWith(
          (states) => states.isNotEmpty
              ? const Color(0xff1988db)
              : Colors.grey.shade500,
        ),
      ),
    );
  }
}
