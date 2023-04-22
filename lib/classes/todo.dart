class Todo {
  Todo(this.name, this.date);
  Todo.fromJson(Map<String, dynamic> todo) : name = todo['name'], date = DateTime.parse(todo['date']);

  String name;
  DateTime date;

  Map<String, dynamic> toJson() {
    return {'name': name, 'date': date.toIso8601String()};
  }
}
