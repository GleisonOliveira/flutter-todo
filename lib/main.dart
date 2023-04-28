import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/states/home_state.dart';
import 'package:todo_list/states/todos_state.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  List<Widget> getActions(
      int pageIndex, BuildContext context, TodosState todosState) {
    if (pageIndex == 0 || pageIndex == 2) {
      return [];
    }

    List<Widget> actions = [];

    if (todosState.todos.isNotEmpty) {
      actions.add(IconButton(
          onPressed: () {
            todosState.clearTodos(context);
          },
          icon: Icon(
            Icons.delete_forever,
            color: Colors.grey.shade700,
          )));
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodosState>(
          create: (_) => TodosState(),
        ),
        ChangeNotifierProvider<HomeState>(
          create: (_) => HomeState(),
        ),
      ],
      child:
          Consumer<HomeState>(builder: (context, HomeState homeState, child) {
        return MaterialApp(

          debugShowCheckedModeBanner: false,
          supportedLocales: const [
            Locale('pt', 'BR'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: SafeArea(
            child: Consumer<TodosState>(
                builder: (context, TodosState todosState, child) {
              return Scaffold(
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: homeState.page,
                  onTap: (int index) {
                    homeState.setPage(index);
                  },
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.schedule), label: "Meu dia"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.check_circle), label: "Tarefas"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings), label: "Configurações"),
                  ],
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    todosState.resetTodo();
                    homeState.openTaskScreen(context);
                  },
                  child: const Icon(Icons.add),
                ),
                appBar: AppBar(
                  title: Text(
                    homeState.pages[homeState.page].appBar.toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  leading: Builder(
                    builder: (context) => IconButton(
                      onPressed: () {
                        homeState.setPage(0);
                      },
                      icon: const Icon(Icons.home),
                      color: Colors.grey.shade600,
                    ),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  actions: getActions(homeState.page, context, todosState),
                ),
                backgroundColor: Colors.white,
                body: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: homeState.pageController,
                  children: homeState.pages.map((e) => e.page).toList(),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
