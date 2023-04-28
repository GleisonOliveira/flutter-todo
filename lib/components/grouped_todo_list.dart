import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:todo_list/components/empty.dart';
import 'package:todo_list/components/todo_list_item.dart';
import 'package:todo_list/models/date_formatter.dart';
import 'package:todo_list/models/todo.dart';

class GroupedTodoList extends StatelessWidget {
  const GroupedTodoList({Key? key, required this.todos}) : super(key: key);
  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return todos.isEmpty ? const Empty(): GroupedListView<dynamic, DateTime>(
      elements: todos,
      sort: false,
      groupBy: (element) {
        var date = element.date;

        return DateTime(date.year, date.month, date.day);
      },
      groupComparator: (value1, value2) {
        var date1 = DateTime(value1.year, value1.month, value1.day);
        var date2 = DateTime(value2.year, value2.month, value2.day);

        return date1.compareTo(date2);
      },
      useStickyGroupSeparators: true,
      floatingHeader: false,
      shrinkWrap: false,
      groupSeparatorBuilder: (value) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              DateFormatter().formatInDays(value),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      itemBuilder: (c, todo) {
        return TodoListItem(todo);
      },
    );
  }
}
