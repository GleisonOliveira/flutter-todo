import 'package:flutter/material.dart';
import 'package:todo_list/models/date_formatter.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repositories/todo_repository.dart';

const localeName = "pt_BR";

class TodosState extends ChangeNotifier {
  List<Todo> todos = [];
  final TodoRepository repository = TodoRepository();
  String todo = "";
  DateTime date = DateTime.now();
  TextEditingController todoInputController = TextEditingController();
  TextEditingController todoDateInputController = TextEditingController();

  TodosState() {
    formatDate();

    getTodos();
  }

  void sortList() {
    todos.sort((a, b) {
      return a.date.compareTo(b.date);
    });
  }

  void addTodo(Todo todo) {
    todos.add(todo);
    sortList();

    repository.save(todos);

    todoInputController.text = "";
    this.todo = "";

    notifyListeners();
  }

  void insertTodo(Todo todo, int index) {
    todos.insert(index, todo);

    notifyListeners();
  }

  void deleteTodo(Todo todo) {
    todos.remove(todo);
    sortList();

    repository.save(todos);

    notifyListeners();
  }

  void clearTodos() {
    todos.clear();

    repository.save(todos);

    notifyListeners();
  }

  Future<List<Todo>> getTodos() async {
    todos = await repository.get();

    notifyListeners();

    return todos;
  }

  void changeDate(DateTime date) {
    this.date = date;

    formatDate();

    notifyListeners();
  }

  void formatDate() {
    DateFormatter()
        .format(
            locale: localeName,
            format: "E - dd/MM/yyyy - HH:mm",
            dateTime: date)
        .then(
            (formattedValue) => todoDateInputController.text = formattedValue);
  }

  void changeText(String text) {
    todo = text;

    notifyListeners();
  }
}
