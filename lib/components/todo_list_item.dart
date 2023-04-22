import 'package:date_formatter/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/classes/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem(this.todo, {Key? key, this.onDelete}) : super(key: key);

  final Todo todo;
  final Function(Todo)? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.20,
            motion: const BehindMotion(),
            children: [
              Expanded(
                child: Material(
                  color: Colors.red,
                  child: InkWell(
                    splashColor: Colors.red.shade900,
                    onTap: () {
                      onDelete!(todo);
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
              )
            ],
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xffebebeb),
            ),
            padding: const EdgeInsets.all(10),
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
                      DateFormatter.formatDateTime(
                        dateTime: todo.date,
                        outputFormat: "dd/MM/yyyy",
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  todo.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
