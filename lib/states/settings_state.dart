import 'package:flutter/material.dart';
import 'package:todo_list/extensions/dark_mode.dart';
import 'package:todo_list/models/setting.dart';
import 'package:todo_list/repositories/settings_repository.dart';
import 'package:todo_list/themes/dark_theme.dart';
import 'package:todo_list/themes/light_theme.dart';

class SettingsState extends ChangeNotifier {
  Setting? settings;
  final SettingsRepository repository = SettingsRepository();

  SettingsState() {
    repository
        .get()
        .then((value) {
      settings = value;
      notifyListeners();
    }
  );
}

String getThemeName() {
  return settings!.theme;
}

ThemeData getTheme(BuildContext context, Brightness? systemTheme) {
  if (settings == null) {
    return context.isDarkMode ? DarkTheme().theme : LightTheme().theme;
  }

  if (settings!.theme == "dark") {
    return DarkTheme().theme;
  }

  if (settings!.theme == "light") {
    return LightTheme().theme;
  }

  return context.isDarkMode ? DarkTheme().theme : LightTheme().theme;
}

void changeTheme(String theme) {
  settings!.theme = theme;

  repository.save(settings!);

  notifyListeners();
}}
