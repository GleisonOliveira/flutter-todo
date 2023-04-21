import 'package:flutter/material.dart';
import 'package:todo_list/classes/task.dart';
import 'package:todo_list/components/todo_list_item.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];
  final TextEditingController taskInputController = TextEditingController();
  String task = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: taskInputController,
                        onChanged: (String text) {
                          setState(() {
                            task = text;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Digite sua tarefa",
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
                      onPressed: task.isEmpty == true
                          ? null
                          : () {
                              setState(() {
                                tasks.add(Task(
                                    taskInputController.text.trim(), DateTime.now()));
                                task = "";
                              });
                              taskInputController.text = "";
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
                  child: ListView(
                    shrinkWrap: true,
                    children: tasks.map((task) => TodoListItem(task)).toList(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          "Você possui ${tasks.length.toString()} tarefas pendentes"),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: tasks.isEmpty == true
                          ? null
                          : () {
                              setState(() {
                                tasks.clear();
                              });
                            },
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
    );
  }
}
