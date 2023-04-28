import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/components/simple_todo_list.dart';
import 'package:todo_list/states/todos_state.dart';

class DayPage extends StatelessWidget {
  const DayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodosState todosState = Provider.of<TodosState>(context);

    return Column(
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: SlidableAutoCloseBehavior(
            child: SimpleTodoList(
              todos: todosState.todos,
            ),
          ),
        ),
      ],
    );
  }
}
