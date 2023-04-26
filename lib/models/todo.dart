class Todo {
  Todo(this.name, this.date, {this.finished = false});

  Todo.fromJson(Map<String, dynamic> todo)
      : name = todo['name'],
        date = DateTime.parse(todo['date']),
        finished = todo['finished'];

  String name;
  DateTime date;
  bool finished = false;

  Map<String, dynamic> toJson() {
    return {'name': name, 'date': date.toIso8601String(), 'finished': finished};
  }
}
