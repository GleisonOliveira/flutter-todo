import 'package:flutter/material.dart';

class AppColorScheme extends ThemeExtension<AppColorScheme> {
  AppColorScheme(
      {this.groupBackgroundColor,
      this.statusBarColor,
      this.statusBarBrightness});

  Color? groupBackgroundColor = const Color(0xff323232);
  Color? statusBarColor = const Color(0xff202020);
  Brightness? statusBarBrightness = Brightness.light;

  @override
  AppColorScheme copyWith(
          {Color? groupBackgroundColor,
          Color? statusBarColor,
          Brightness? statusBarBrightness}) =>
      AppColorScheme(
        groupBackgroundColor: groupBackgroundColor ?? this.groupBackgroundColor,
        statusBarColor: statusBarColor ?? this.statusBarColor,
        statusBarBrightness: statusBarBrightness ?? this.statusBarBrightness,
      );

  @override
  ThemeExtension<AppColorScheme> lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) {
      return this;
    }

    return AppColorScheme(
      groupBackgroundColor: Color.lerp(groupBackgroundColor, other.groupBackgroundColor, t),
      statusBarColor:  Color.lerp(statusBarColor, other.statusBarColor, t),
      statusBarBrightness: statusBarBrightness,
    );
  }
}
