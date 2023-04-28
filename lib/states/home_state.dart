import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:todo_list/models/home.dart';
import 'package:todo_list/pages/day_page.dart';
import 'package:todo_list/pages/home_page.dart';
import 'package:todo_list/pages/todo_page.dart';

class HomeState extends ChangeNotifier {
  int page = 0;
  PageController pageController = PageController();

  final List<Home> pages = [
    Home(page: const DayPage(), appBar: "MEU DIA",),
    Home(page: const HomePage(), appBar: "TODAS AS TAREFAS"),
    Home(page: Container(), appBar: "CONFIGURAÇÕES",)
  ];

  void setPage(int index) {
    page = index;

    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.linearToEaseOut);

    notifyListeners();
  }

  void openTaskScreen(BuildContext context, {bool edit = false}) {
    showBarModalBottomSheet(
      barrierColor: Colors.black.withAlpha(70),
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: TodoPage(edit: edit),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
    );
  }
}
