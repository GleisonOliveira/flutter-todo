import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/setting.dart';

const settingsKey = "settings";

class SettingsRepository {
  late SharedPreferences sharedPreferences;

  SettingsRepository() {
    SharedPreferences.getInstance().then((instance) {
      sharedPreferences = instance;
    });
  }

  Future<Setting> get() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? settingsJson = sharedPreferences.getString(settingsKey);

    if (settingsJson == null) {
      return Setting();
    }

    return Setting.fromJson(
        (json.decode(settingsJson) as Map<String, dynamic>));
  }

  void save(Setting settings) {
    sharedPreferences.setString(settingsKey, json.encode(settings));
  }
}
