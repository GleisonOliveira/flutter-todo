import 'package:flutter/material.dart';
import 'package:todo_list/models/home.dart';
import 'package:todo_list/pages/home_page.dart';

class HomeState extends ChangeNotifier {
  int page = 0;
  PageController pageController = PageController();
  final List<Home> pages = [
    Home(page: const HomePage(), appBar: "TODAS AS TAREFAS"),
    Home(page: Container(), appBar: "Configurações",)
  ];

  void setPage(int index) {
    page = index;

    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.linearToEaseOut);

    notifyListeners();
  }
}
