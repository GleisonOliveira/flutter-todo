import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/components/todo_list_item.dart';
import 'package:todo_list/states/todos_state.dart';

const localeName = "pt_BR";

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodosState todosState = Provider.of<TodosState>(context);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: SlidableAutoCloseBehavior(
                child: ListView(
                  shrinkWrap: false,
                  children: todosState.todos
                      .map((todo) =>
                      TodoListItem(todo))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
