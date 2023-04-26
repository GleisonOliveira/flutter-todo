import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/date_formatter.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/states/todos_state.dart';

class TodoListItem extends StatefulWidget {
  const TodoListItem(this.todo, {Key? key, this.onDelete}) : super(key: key);

  final Todo todo;
  final Function(Todo)? onDelete;

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  String date = "";

  @override
  void initState() {
    super.initState();

    DateFormatter()
        .format(
            locale: "pt_BR",
            format: "E - dd/MM/yyyy - HH:mm",
            dateTime: widget.todo.date)
        .then((formattedDate) {
      setState(() {
        date = formattedDate;
      });
    });
  }

  @override
  void didUpdateWidget(TodoListItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.todo.date != widget.todo.date) {
      DateFormatter()
          .format(
              locale: "pt_BR",
              format: "E - dd/MM/yyyy - HH:mm",
              dateTime: widget.todo.date)
          .then((formattedDate) {
        setState(() {
          date = formattedDate;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TodosState todosState = Provider.of<TodosState>(context);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Slidable(
            groupTag: "tag",
            closeOnScroll: true,
            startActionPane: ActionPane(
              extentRatio: 0.40,
              motion: const BehindMotion(),
              children: [
                Expanded(
                  child: Material(
                    color: Colors.green,
                    child: InkWell(
                      splashColor: Colors.green.shade900,
                      onTap: () {
                        print("make action");
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Editar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Material(
                    color: Colors.red,
                    child: InkWell(
                      splashColor: Colors.red.shade900,
                      onTap: () {
                        widget.onDelete!(widget.todo);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Apagar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              todosState.setFinished(widget.todo, !widget.todo.finished, context);
                            },
                            style: TextButton.styleFrom(
                              fixedSize: const Size(50, 50),
                              backgroundColor: widget.todo.finished == true ? Colors.green : const Color(0xffebebeb),
                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              widget.todo.finished == true
                                  ? Icons.check
                                  : Icons.schedule,
                              color: widget.todo.finished == true
                                  ? Colors.white
                                  : Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Color(0xff0984e3),
                                size: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.todo.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          thickness: 1,
          height: 5,
        )
      ],
    );
  }
}
