import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/classes/date_formatter.dart';
import 'package:todo_list/classes/todo.dart';
import 'package:todo_list/components/todo_list_item.dart';
import 'package:todo_list/repositories/todo_repository.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

const localeName = "pt_BR";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];
  final TextEditingController todoInputController = TextEditingController();
  final TextEditingController todoDateInputController = TextEditingController();
  final TodoRepository repository = TodoRepository();
  String todo = "";
  DateTime date = DateTime.now();

  void onDelete(Todo todo) {
    int removalIndex = todos.indexOf(todo);

    todos.remove(todo);

    sortList();

    setState(() {
      todos = todos;
    });

    repository.save(todos);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("A tarefa '${todo.name}' foi deletada."),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () {
            setState(() {
              todos.insert(removalIndex, todo);
            });
          },
        ),
      ),
    );
  }

  void clearTodos() {
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
                  setState(() {
                    todos.clear();
                  });

                  repository.save(todos);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Todas as tarefas foram deletada."),
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

  void formatDate() {
    DateFormatter()
        .format(
            locale: localeName,
            format: "E - dd/MM/yyyy - HH:mm",
            dateTime: date)
        .then(
            (formattedValue) => todoDateInputController.text = formattedValue);
  }

  void sortList() {
    todos.sort((a, b) {
      return a.date.compareTo(b.date);
    });
  }

  void addTodo() {
    todos.add(Todo(todoInputController.text.trim(), date));

    sortList();

    setState(() {
      todos = todos;
    });

    todoInputController.text = "";
    repository.save(todos);
  }

  Future<void> chooseDate() async {
    DateTime? pickedDate = await showOmniDateTimePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: date,
      isForce2Digits: true,
      lastDate: DateTime(DateTime.now().year + 1000),
      is24HourMode: true,
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      date = pickedDate;
    });

    formatDate();
  }

  @override
  void initState() {
    super.initState();

    formatDate();

    repository.get().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: todoInputController,
                              onChanged: (String text) {
                                setState(() {
                                  todo = text;
                                });
                              },
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: "Digite sua tarefa",
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffebebeb),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffebebeb),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              readOnly: true,
                              controller: todoDateInputController,
                              onTap: chooseDate,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffebebeb),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffebebeb),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: todo.isEmpty == true ? null : addTodo,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 19),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.add,
                                    size: 14,
                                  ),
                                  Text(
                                    "Adicionar",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Flexible(
                        fit: FlexFit.tight,
                        child: SlidableAutoCloseBehavior (
                          child: ListView(
                            shrinkWrap: false,
                            children: todos
                                .map((todo) =>
                                    TodoListItem(todo, onDelete: onDelete))
                                .toList(),
                          ),
                        ),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                "Você possui '${todos.length.toString()}' tarefas pendentes"),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            onPressed:
                                todos.isEmpty == true ? null : clearTodos,
                            child: Row(
                              children: const [
                                Icon(Icons.delete),
                                Text(
                                  "Limpar tudo",
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
