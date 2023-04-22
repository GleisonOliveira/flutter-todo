import 'package:flutter/material.dart';
import 'package:todo_list/classes/todo.dart';
import 'package:todo_list/components/todo_list_item.dart';
import 'package:todo_list/repositories/todo_repository.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];
  final TextEditingController todoInputController = TextEditingController();
  final TodoRepository repository = TodoRepository();
  String todo = "";

  void onDelete(Todo todo) {
    int removalIndex = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
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

  @override
  void initState() {
    super.initState();

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
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            onPressed: todo.isEmpty == true
                                ? null
                                : () {
                                    setState(() {
                                      todos.add(Todo(
                                          todoInputController.text.trim(),
                                          DateTime.now()));
                                      todo = "";
                                    });
                                    todoInputController.text = "";
                                    repository.save(todos);
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                            ),
                            child: const Icon(Icons.add),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: ListView(
                          shrinkWrap: false,
                          children: todos
                              .map((todo) =>
                                  TodoListItem(todo, onDelete: onDelete))
                              .toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
