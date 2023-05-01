import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/extensions/color_scheme.dart';
import 'package:todo_list/states/home_state.dart';
import 'package:todo_list/states/settings_state.dart';
import 'package:todo_list/states/todos_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(providers: [
      Provider.value(value: await SharedPreferences.getInstance()),
      ChangeNotifierProvider<TodosState>(
        create: (_) => TodosState(),
      ),
      ChangeNotifierProvider<HomeState>(
        create: (_) => HomeState(),
      ),
      ChangeNotifierProvider<SettingsState>(
        create: (_) => SettingsState(),
      ),
    ], child: const App()),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Brightness? systemTheme;

  @override
  void initState() {
    super.initState();

    var window = WidgetsBinding.instance.window;
    window.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();

      var brightness = window.platformBrightness;

      setState(() {
        systemTheme = brightness;
      });
    };
  }

  List<Widget> getActions(
      int pageIndex, BuildContext context, TodosState todosState) {
    if (pageIndex == 0 || pageIndex == 2) {
      return [];
    }

    List<Widget> actions = [];

    if (todosState.todos.isNotEmpty) {
      actions.add(IconButton(
          splashRadius: 20,
          onPressed: () {
            todosState.clearTodos(context);
          },
          icon: Icon(
            Icons.delete_forever,
            color: Theme.of(context).appBarTheme.foregroundColor,
          )));
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    HomeState homeState = Provider.of<HomeState>(context);
    SettingsState settingsState = Provider.of<SettingsState>(context);

    return MaterialApp(
      theme: settingsState.getTheme(context, systemTheme),
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(builder: (BuildContext context) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor:
          Theme.of(context).extension<AppColorScheme>()?.statusBarColor,
          statusBarBrightness: Theme.of(context)
              .extension<AppColorScheme>()
              ?.statusBarBrightness,
          statusBarIconBrightness: Theme.of(context)
              .extension<AppColorScheme>()
              ?.statusBarBrightness,
        ));
        return SafeArea(
          child: Consumer<TodosState>(builder: (context, todosState, child) {
            return Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: homeState.page,
                onTap: (int index) {
                  if(index == homeState.page) {
                    return ;
                  }

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
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                leading: Builder(
                  builder: (context) => IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      homeState.setPage(0);
                    },
                    icon: Icon(
                      Icons.home,
                      color: Theme.of(context).appBarTheme.foregroundColor,
                    ),
                  ),
                ),
                elevation: 1,
                backgroundColor:
                Theme.of(context).appBarTheme.backgroundColor,
                actions: getActions(homeState.page, context, todosState),
              ),
              body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: homeState.pageController,
                children: homeState.pages.map((e) => e.page).toList(),
              ),
            );
          }),
        );
      },)
    );
  }
}
