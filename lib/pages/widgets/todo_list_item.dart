import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tarefapp/models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    Key? key,
    required this.todo,
    required this.delete,
  }) : super(key: key);

  final Todo todo;
  final Function(Todo) delete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all((6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(DateFormat.yMd().add_jm().format(todo.dateTime)),
              Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        endActionPane: ActionPane(
          extentRatio: 0.22,
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (deletar) {
                delete(todo);
              },
              autoClose: true,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
