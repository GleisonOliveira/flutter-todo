import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/components/todo_list_item.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:todo_list/states/home_state.dart';
import 'package:todo_list/states/todos_state.dart';

const localeName = "pt_BR";

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodosState todosState = Provider.of<TodosState>(context);
    HomeState homeState = Provider.of<HomeState>(context);

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

    void addTodo() {
      FocusManager.instance.primaryFocus?.unfocus();
      todosState.addTodo(
          Todo(todosState.todoInputController.text.trim(), todosState.date));
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

    void onChangePage(int index) {
      homeState.setPage(index);
    }

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
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
                        onPressed: todosState.todo.isEmpty == true
                            ? null
                            : addTodo,
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
                      children: todosState.todos
                          .map((todo) =>
                          TodoListItem(todo, onDelete: onDelete))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
