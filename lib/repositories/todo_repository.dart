import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/todo.dart';

const TodoListKey = "todo_list";

class TodoRepository {
  late SharedPreferences sharedPreferences;

  TodoRepository() {
    SharedPreferences.getInstance().then((instance) {
      sharedPreferences = instance;
    });
  }

  void save(List<Todo> todos) {
    sharedPreferences.setString(TodoListKey, json.encode(todos));
  }

  Future<List<Todo>> get() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? todosJson = sharedPreferences.getString(TodoListKey);

    if (todosJson == null) {
      return [];
    }

    return (json.decode(todosJson) as List)
        .map((value) => Todo.fromJson(value))
        .toList();
  }
}
