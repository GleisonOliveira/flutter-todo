import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
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
      DateTime? pickedDate = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        firstDate: DateTime(DateTime.now().year - 100),
        initialDate: todosState.date,
        lastDate: DateTime(DateTime.now().year + 1000),
      );

      if (pickedDate == null) {
        return;
      }

      todosState.changeDate(pickedDate);
    }

    Future<void> chooseHour() async {
      Navigator.of(context).push(
        showPicker(
          borderRadius: 5,
          context: context,
          is24HrFormat: true,
          cancelText: "CANCELAR",
          okText: "OK",
          value: Time(hour: DateTime.now().hour, minute: DateTime.now().minute),
          onChange: (time) {
            DateTime selectedDay = DateTime(
                todosState.date.year,
                todosState.date.month,
                todosState.date.day,
                time.hour,
                time.minute);

            todosState.changeDate(selectedDay);
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.grey.shade600,
                ),
              )
            ],
          ),
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
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Nome da tarefa",
                    hintText: "Insira uma nova tarefa aqui",
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
                  decoration: const InputDecoration(
                    labelText: "Data da tarefa",
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
                width: 15,
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  readOnly: true,
                  controller: todosState.todoHourInputController,
                  onTap: chooseHour,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: "Hora da tarefa",
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
              Switch(
                  value: todosState.finished,
                  onChanged: todosState.changeFinished),
              Text(todosState.finished
                  ? "Marcar tarefa como finalizada"
                  : "Marcar tarefa como não finalizada")
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("Escolha uma cor:"),
          const SizedBox(height: 15),
          BlockPicker(
            pickerColor: todosState.color,
            onColorChanged: (Color color) {
              todosState.changeColor(color);
            },
            availableColors: colors,
            layoutBuilder: pickerLayoutBuilder,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                onPressed: todosState.name.isEmpty == true ? null : manageTodo,
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
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
