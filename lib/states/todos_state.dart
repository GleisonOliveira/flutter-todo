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

  void setFinished(Todo todo, bool finished, BuildContext context) {
    int todoIndex = todos.indexOf(todo);

    todo.finished = finished;

    todos[todoIndex] = todo;

    repository.save(todos);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("A tarefa '${todo.name}' foi marcada como ${finished ? "finalizada" : "agendada"}."),
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
                style:
                ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
