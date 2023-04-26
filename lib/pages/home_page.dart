import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/models/todo_list_item.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:todo_list/states/todos_state.dart';

const localeName = "pt_BR";

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodosState todosState = Provider.of<TodosState>(context);

    void onDelete(Todo todo) {
      int removalIndex = todosState.todos.indexOf(todo);

      todosState.deleteTodo(todo);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("A tarefa '${todo.name}' foi deletada."),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: () {
              todosState.insertTodo(todo, removalIndex);
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
              "Tem certeza que deseja deletar todas as '${todosState.todos.length.toString()}' tarefa(s)?."),
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

                    todosState.clearTodos();

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

    void addTodo() {
      todosState.addTodo(Todo(todosState.todoInputController.text.trim(), todosState.date));
    }

    Future<void> chooseDate() async {
      DateTime? pickedDate = await showOmniDateTimePicker(
        context: context,
        firstDate: DateTime.now(),
        initialDate: todosState.date,
        isForce2Digits: true,
        lastDate: DateTime(DateTime.now().year + 1000),
        is24HourMode: true,
      );

      if (pickedDate == null) {
        return;
      }

      todosState.changeDate(pickedDate);
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {},
              color: Colors.black,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
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
                              controller: todosState.todoInputController,
                              onChanged: (String text) {
                                todosState.changeText(text);
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
                              controller: todosState.todoDateInputController,
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
                              onPressed: todosState.todo.isEmpty == true ? null : addTodo,
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
                        child: SlidableAutoCloseBehavior(
                          child: ListView(
                            shrinkWrap: false,
                            children: todosState.todos.map((todo) =>
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
                                "Você possui '${todosState.todos.length.toString()}' tarefas pendentes"),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            onPressed:
                            todosState.todos.isEmpty == true ? null : clearTodos,
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

