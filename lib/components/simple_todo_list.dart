import 'package:flutter/material.dart';
import 'package:todo_list/components/empty.dart';
import 'package:todo_list/components/todo_list_item.dart';
import 'package:todo_list/extensions/color_scheme.dart';
import 'package:todo_list/models/todo.dart';

class SimpleTodoList extends StatelessWidget {
  const SimpleTodoList({Key? key, required this.todos}) : super(key: key);
  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return todos.isEmpty
        ? const Empty()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).extension<AppColorScheme>()?.groupBackgroundColor,
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Hoje",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: todos
                    .where((todo) {
                      var now = DateTime.now();
                      var todoDate = todo.date;
                      return now.year == todoDate.year &&
                          now.month == todoDate.month &&
                          now.day == todoDate.day;
                    })
                    .map((todo) => TodoListItem(todo))
                    .toList(),
              ),
            ],
          );
  }
}
