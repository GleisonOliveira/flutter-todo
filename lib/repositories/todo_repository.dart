import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/todo.dart';

const todoListKey = "todo_list";

class TodoRepository {
  late SharedPreferences sharedPreferences;

  TodoRepository() {
    SharedPreferences.getInstance().then((instance) {
      sharedPreferences = instance;
    });
  }

  void save(List<Todo> todos) {
    sharedPreferences.setString(todoListKey, json.encode(todos));
  }

  Future<List<Todo>> get() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? todosJson = sharedPreferences.getString(todoListKey);

    if (todosJson == null) {
      return [];
    }

    return (json.decode(todosJson) as List)
        .map((value) => Todo.fromJson(value))
        .toList();
  }
}
