import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:todo_list/extensions/color_scheme.dart';
import 'package:todo_list/models/home.dart';
import 'package:todo_list/pages/day_page.dart';
import 'package:todo_list/pages/home_page.dart';
import 'package:todo_list/pages/settings_page.dart';
import 'package:todo_list/pages/todo_page.dart';
import 'package:todo_list/themes/light_theme.dart';

class HomeState extends ChangeNotifier {
  int page = 0;
  PageController pageController = PageController();
  final List<Home> pages = [
    Home(
      page: const DayPage(),
      appBar: "MEU DIA",
    ),
    Home(page: const HomePage(), appBar: "TODAS AS TAREFAS"),
    Home(
      page: const SettingsPage(),
      appBar: "CONFIGURAÇÕES",
    )
  ];
  final Map<String, ThemeData> themes = {"light": LightTheme().theme};
  String theme = "light";

  void setPage(int index) {
    page = index;

    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linearToEaseOut);

    notifyListeners();
  }

  void changeTheme(String theme) {
    if (themes[theme] != null) {
      this.theme = theme;

      notifyListeners();
    }
  }

  void openTaskScreen(BuildContext context, {bool edit = false}) {
    showBarModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      overlayStyle: SystemUiOverlayStyle(
        statusBarColor:
            Theme.of(context).extension<AppColorScheme>()?.statusBarColor,
        statusBarIconBrightness:
            Theme.of(context).extension<AppColorScheme>()?.statusBarBrightness,
        statusBarBrightness: Theme.of(context)
            .extension<AppColorScheme>()
            ?.statusBarBrightness, // For iOS (dark icons)
      ),
      barrierColor: Colors.black.withAlpha(200),
      context: context,
      useRootNavigator: false,
      builder: (context) =>TodoPage(edit: edit),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
    );
  }
}
