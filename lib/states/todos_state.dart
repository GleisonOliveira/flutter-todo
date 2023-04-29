import 'package:flutter/material.dart';
import 'package:todo_list/models/date_formatter.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repositories/todo_repository.dart';

const localeName = "pt_BR";

class TodosState extends ChangeNotifier {
  List<Todo> todos = [];
  final TodoRepository repository = TodoRepository();
  Todo todo = Todo();
  TextEditingController todoInputController = TextEditingController();
  TextEditingController todoDateInputController = TextEditingController();
  TextEditingController todoHourInputController = TextEditingController();
  int todoIndex = 0;

  TodosState() {
    getTodos();
  }

  void resetTodo() {
    todoInputController.text = "";
    todo.name = "";
    todo.color = Colors.blue;
    todo.notes = null;
    DateTime now = DateTime.now();
    todo.date = DateTime(now.year, now.month, now.day, 0, 0);

    formatDate();
    formatHour();

    notifyListeners();
  }

  void sortList() {
    todos.sort((a, b) {
      return a.date!.compareTo(b.date!);
    });
  }

  void addTodo() {
    todos.add(todo.copyWith());
    sortList();

    repository.save(todos);

    notifyListeners();
  }

  void updateTodo() {
    Todo todo = todos[todoIndex];

    todo.color = this.todo.color;
    todo.date = this.todo.date;
    todo.finished = this.todo.finished;
    todo.name = this.todo.name;
    todo.notes = this.todo.notes;

    todos[todoIndex] = todo;

    sortList();

    repository.save(todos);

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
                  backgroundColor: const Color(0xffff6b6b),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1dd1a1),
                ),
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
    todo.date = date;

    formatDate();
    formatHour();

    notifyListeners();
  }

  void formatDate() {
    DateFormatter()
        .format(locale: localeName, format: "E - dd/MM/yyyy", dateTime: todo.date!)
        .then(
            (formattedValue) => todoDateInputController.text = formattedValue);
  }

  void formatHour() {
    DateFormatter()
        .format(locale: localeName, format: "HH:mm", dateTime: todo.date!)
        .then(
            (formattedValue) => todoHourInputController.text = formattedValue);
  }

  void changeText(String text) {
    todo.name = text;

    notifyListeners();
  }

  void changeColor(Color color) {
    todo.color = color;

    notifyListeners();
  }

  void changeFinished(bool finished) {
    todo.finished = finished;

    notifyListeners();
  }

  void changeTodo(Todo todo) {
    this.todo = todo.copyWith();

    formatHour();
    formatDate();

    todoInputController.text = todo.name!;

    todoIndex = todos.indexOf(todo);

    notifyListeners();
  }
}
