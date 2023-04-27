import 'package:flutter/material.dart';

class Todo {
  Todo(this.name, this.date, {this.finished = false, this.color = Colors.blue});

  Todo.fromJson(Map<String, dynamic> todo)
      : name = todo['name'],
        date = DateTime.parse(todo['date']),
        color = Color(todo['color']),
        finished = todo['finished'];

  String name;
  DateTime date;
  bool finished = false;
  Color color = Colors.blue;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date.toIso8601String(),
      'finished': finished,
      'color': color.value
    };
  }
}
