import 'package:flutter/material.dart';

class Todo {
  Todo(
      {this.name,
      this.date,
      this.finished = false,
      this.color = Colors.blue,
      this.notes});

  Todo.fromJson(Map<String, dynamic> todo)
      : name = todo['name'],
        date = DateTime.parse(todo['date']),
        color = Color(todo['color'] ?? Colors.blue.value),
        finished = todo['finished'],
        notes = todo['notes'];

  String? name = "";
  DateTime? date = DateTime.now();
  bool finished = false;
  Color color = Colors.blue;
  String? notes;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date != null
          ? date!.toIso8601String()
          : DateTime.now().toIso8601String(),
      'finished': finished,
      'color': color.value,
      'notes': notes,
    };
  }

  Todo copyWith({
    String? name,
    DateTime? date,
    String? notes,
    bool? finished,
    Color? color,
  }) {
    return Todo(
        name: name ?? this.name,
        date: date ?? this.date,
        notes: notes ?? this.notes,
        finished: finished ?? this.finished,
        color: color ?? this.color);
  }
}
