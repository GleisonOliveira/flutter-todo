class Setting {
  Setting({this.theme = "auto"});

  Setting.fromJson(Map<String, dynamic> todo) : theme = todo['theme'];

  String theme;

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
    };
  }
}
