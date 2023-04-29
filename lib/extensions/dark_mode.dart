import 'dart:ui';
import 'package:flutter/widgets.dart';

extension DarkMode on BuildContext {
  bool get isDarkMode {
    final brightness = MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness;
    return brightness == Brightness.dark;
  }
}