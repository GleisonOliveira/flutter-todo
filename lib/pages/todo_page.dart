import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/components/notes.dart';
import 'package:todo_list/states/settings_state.dart';
import 'package:todo_list/states/todos_state.dart';

const List<Color> colors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black54,
  Colors.black,
];

class TodoPage extends StatelessWidget {
  const TodoPage({Key? key, this.edit = false}) : super(key: key);
  final bool edit;

  @override
  Widget build(BuildContext context) {
    TodosState todosState = Provider.of<TodosState>(context);

    Widget pickerLayoutBuilder(
        BuildContext context, List<Color> colors, PickerItem child) {
      Size screen = MediaQuery.of(context).size;

      return SizedBox(
        width: screen.width,
        height: 170,
        child: GridView.count(
          crossAxisCount: 7,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          children: [for (Color color in colors) child(color)],
        ),
      );
    }

    void manageTodo() {
      FocusManager.instance.primaryFocus?.unfocus();

      if (edit) {
        todosState.updateTodo();

        Navigator.of(context).pop();

        return;
      }

      todosState.addTodo();

      Navigator.of(context).pop();
    }

    Future<void> chooseDate() async {
      FocusManager.instance.primaryFocus?.unfocus();

      DateTime? pickedDate = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        firstDate: DateTime(DateTime.now().year - 100),
        initialDate: todosState.todo.date!,
        lastDate: DateTime(DateTime.now().year + 1000),
      );

      if (pickedDate == null) {
        return;
      }

      todosState.changeDate(pickedDate);
    }

    Future<void> chooseHour() async {
      FocusManager.instance.primaryFocus?.unfocus();

      Navigator.of(context).push(
        showPicker(
          borderRadius: 5,
          context: context,
          is24HrFormat: true,
          cancelText: "CANCELAR",
          accentColor: Theme.of(context).primaryColor,
          okText: "OK",
          value: Time(hour: DateTime.now().hour, minute: DateTime.now().minute),
          onChange: (time) {
            DateTime selectedDay = DateTime(
                todosState.todo.date!.year,
                todosState.todo.date!.month,
                todosState.todo.date!.day,
                time.hour,
                time.minute);

            todosState.changeDate(selectedDay);
          },
        ),
      );
    }

    void openNotes() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Dialog(
            backgroundColor: Colors.transparent,
            child: Notes(),
          );
        },
      );
    }

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                splashRadius: 20,
                onPressed: () {
                  todosState.notesInputController.text = "";
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.grey.shade600,
                ),
              )
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: todosState.todoInputController,
                          onChanged: (String text) {
                            todosState.changeText(text);
                          },
                          style: TextStyle(
                              fontSize: 14,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Nome da tarefa",
                            hintText: "Insira uma nova tarefa aqui",
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: Theme.of(context)
                                  .inputDecorationTheme
                                  .outlineBorder!,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: Theme.of(context)
                                  .inputDecorationTheme
                                  .outlineBorder!,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
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
                          decoration: InputDecoration(
                            labelText: "Data da tarefa",
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: Theme.of(context)
                                  .inputDecorationTheme
                                  .outlineBorder!,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: Theme.of(context)
                                  .inputDecorationTheme
                                  .outlineBorder!,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          readOnly: true,
                          controller: todosState.todoHourInputController,
                          onTap: chooseHour,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            labelText: "Hora da tarefa",
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: Theme.of(context)
                                  .inputDecorationTheme
                                  .outlineBorder!,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color!
                                    .withAlpha(50),
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
                      Switch(
                          value: todosState.todo.finished,
                          onChanged: todosState.changeFinished),
                      Text(todosState.todo.finished
                          ? "Marcar tarefa como finalizada"
                          : "Marcar tarefa como não finalizada")
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Notas",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: openNotes,
                    child: const NotesBox(),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Escolha uma cor:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  BlockPicker(
                    pickerColor: todosState.todo.color!,
                    onColorChanged: (Color color) {
                      todosState.changeColor(color);
                    },
                    availableColors: colors,
                    layoutBuilder: pickerLayoutBuilder,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 18,
              bottom: 18,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                  onPressed:
                      todosState.todo.name!.isEmpty == true ? null : manageTodo,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize: const Size(120, 40)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        edit ? Icons.refresh : Icons.save,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        edit ? "Atualizar" : "Salvar",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotesBox extends StatelessWidget {
  const NotesBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodosState todosState = Provider.of<TodosState>(context);

    if (todosState.todo.notes == null ||
        todosState.todo.notes?.isEmpty == true) {
      return DottedBorder(
        color: Theme.of(context)
            .inputDecorationTheme
            .outlineBorder!
            .color!, //color of dotted/dash line
        strokeWidth: 3, //thickness of dash/dots
        dashPattern: const [10, 6],
        child: const SizedBox(
          height: 50,
          width: double.infinity,
          child: Center(
            child: Text("Toque para adicionar notas"),
          ),
        ),
      );
    }
    return Text(
      todosState.todo.notes ?? "",
      overflow: TextOverflow.fade,
      maxLines: 5,
    );
  }
}
