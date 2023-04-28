import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/date_formatter.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/states/home_state.dart';
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
    HomeState homeState = Provider.of<HomeState>(context);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Slidable(
            groupTag: "tag",
            closeOnScroll: true,
            endActionPane: ActionPane(
              extentRatio: 0.30,
              motion: const BehindMotion(),
              children: [
                Expanded(
                  child: Material(
                    color: const Color(0xff1dd1a1),
                    child: InkWell(
                      splashColor: Colors.green.shade900,
                      onTap: () {
                        todosState.changeTodo(widget.todo);
                        homeState.openTaskScreen(context, edit: true);
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
                    color: const Color(0xffff6b6b),
                    child: InkWell(
                      splashColor: Colors.red.shade900,
                      onTap: () {
                        todosState.deleteTodo(widget.todo, context);
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
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: (){
                  todosState.changeTodo(widget.todo);
                  homeState.openTaskScreen(context, edit: true);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                Slidable.of(context)?.dismiss(
                                  ResizeRequest(const Duration(milliseconds: 300), (){

                                  }),
                                  duration: const Duration(milliseconds: 300),
                                );

                                todosState.setFinished(
                                    widget.todo, !widget.todo.finished, context);
                              },
                              style: TextButton.styleFrom(
                                fixedSize: const Size(30, 30),
                                backgroundColor: widget.todo.finished == true
                                    ? const Color(0xff1dd1a1)
                                    : const Color(0xffebebeb),
                                shape: const CircleBorder(),
                              ),
                              child: Icon(
                                widget.todo.finished == true
                                    ? Icons.check
                                    : Icons.schedule,
                                color: widget.todo.finished == true
                                    ? Colors.white
                                    : Colors.grey.shade800,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.5),
                                  color: widget.todo.color,
                                ),
                                width: 5,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
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
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.todo.name,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
