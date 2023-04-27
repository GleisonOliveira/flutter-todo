import 'package:flutter/material.dart';
import 'package:todo_list/models/date_formatter.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repositories/todo_repository.dart';

const localeName = "pt_BR";

class TodosState extends ChangeNotifier {
  List<Todo> todos = [];
  final TodoRepository repository = TodoRepository();
  String name = "";
  DateTime date = DateTime.now();
  Color color = Colors.blue;
  bool finished = false;
  TextEditingController todoInputController = TextEditingController();
  TextEditingController todoDateInputController = TextEditingController();
  TextEditingController todoHourInputController = TextEditingController();
  Todo? todo;
  int todoIndex = 0;

  TodosState() {
    formatDate();
    formatHour();
    getTodos();
  }

  void resetTodo() {
    todoInputController.text = "";
    name = "";
    color = Colors.blue;
    DateTime now = DateTime.now();
    date = DateTime(now.year, now.month, now.day, 0, 0);

    formatDate();
    formatHour();

    todo = null;
  }

  void sortList() {
    todos.sort((a, b) {
      return a.date.compareTo(b.date);
    });
  }

  void addTodo() {
    todos.add(Todo(todoInputController.text.trim(), date,
        color: color, finished: finished));
    sortList();

    repository.save(todos);

    resetTodo();

    notifyListeners();
  }

  void updateTodo() {
    Todo todo = todos[todoIndex];
    todo.color = color;
    todo.date = date;
    todo.finished = finished;
    todo.name = name;

    sortList();

    repository.save(todos);

    resetTodo();

    notifyListeners();
  }

  void insertTodo(Todo todo, int index) {
    todos.insert(index, todo);

    notifyListeners();
  }

  void deleteTodo(Todo todo, BuildContext context) {
    int removalIndex = todos.indexOf(todo);

    todos.remove(todo);
    sortList();

    repository.save(todos);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("A tarefa '${todo.name}' foi deletada."),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () {
            insertTodo(todo, removalIndex);
          },
        ),
      ),
    );

    notifyListeners();
  }

  void setFinished(Todo todo, bool finished, BuildContext context) {
    int todoIndex = todos.indexOf(todo);

    todo.finished = finished;

    todos[todoIndex] = todo;

    repository.save(todos);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "A tarefa '${todo.name}' foi marcada como ${finished ? "finalizada" : "agendada"}."),
      ),
    );

    notifyListeners();
  }

  void clearTodos(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Deletar tarefas."),
        content: Text(
            "Tem certeza que deseja deletar todas as '${todos.length.toString()}' tarefa(s)?."),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: const [
                    Icon(Icons.close),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Cancelar"),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  Navigator.of(context).pop();

                  todos.clear();

                  repository.save(todos);

                  notifyListeners();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Todas as tarefas foram deletadas."),
                    ),
                  );
                },
                child: Row(
                  children: const [
                    Icon(Icons.check),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Limpar"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<Todo>> getTodos() async {
    todos = await repository.get();

    notifyListeners();

    return todos;
  }

  void changeDate(DateTime date) {
    this.date = date;

    formatDate();
    formatHour();

    notifyListeners();
  }

  void formatDate() {
    DateFormatter()
        .format(locale: localeName, format: "E - dd/MM/yyyy", dateTime: date)
        .then(
            (formattedValue) => todoDateInputController.text = formattedValue);
  }

  void formatHour() {
    DateFormatter()
        .format(locale: localeName, format: "HH:mm", dateTime: date)
        .then(
            (formattedValue) => todoHourInputController.text = formattedValue);
  }

  void changeText(String text) {
    name = text;

    notifyListeners();
  }

  void changeColor(Color color) {
    this.color = color;

    notifyListeners();
  }

  void changeFinished(bool finished) {
    this.finished = finished;

    notifyListeners();
  }

  void changeTodo(Todo todo) {
    this.todo = todo;
    name = todo.name;
    color = todo.color;
    finished = todo.finished;
    date = todo.date;

    formatHour();
    formatDate();
    todoInputController.text = todo.name;

    todoIndex = todos.indexOf(todo);

    notifyListeners();
  }
}
