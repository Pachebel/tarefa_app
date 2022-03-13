import 'package:flutter/material.dart';
import 'package:tarefapp/models/todo.dart';
import 'package:tarefapp/pages/widgets/todo_list_item.dart';
import 'package:tarefapp/repository/todorepository.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];

  Todo? deletedTodo;

  int? deletedTodoPos;

  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'adicione uma tarefa',
                          labelStyle: TextStyle(color: Colors.lightBlue),
                          hintText: 'ex. Opa',
                          errorText: errorText,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black,
                            width: 2)
                          )
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if(text.isEmpty) {
                          setState(() {
                            errorText = 'Adicione uma tarefa';
                          });

                          return;
                        }

                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                          errorText = null;
                          todoController.clear();
                          todoRepository.saveTodoList(todos);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue, padding: EdgeInsets.all(15)),
                      child: Icon(
                        Icons.add,
                        size: 32,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          delete: delete,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Numero de tarefas: ${todos.length}',
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: showDeleteDialog,
                      child: Text('apagar tudo'),
                      style: (ElevatedButton.styleFrom(
                        primary: Colors.black,
                      )),
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

  void delete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);


    setState(() {
      todos.remove(todo);
      todoRepository.saveTodoList(todos);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('tem certeza que deseja remover a tarefa: ${todo.title} ?',
            style: TextStyle(shadows: const [
              Shadow(
                  offset: Offset(-10, 5), blurRadius: 10, color: Colors.black)
            ], fontSize: 15)),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'desfazer',
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
            todoRepository.saveTodoList(todos);
          },
          textColor: Colors.white,
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Aviso'),
        content: Text('Realmente deseja apagar tudo?'),
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.lightBlue,
                  backgroundColor: Colors.grey.withOpacity(0.2)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar')),
          TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.red,
                  backgroundColor: Colors.grey.withOpacity(0.2)),
              onPressed: () {
                Navigator.of(context).pop();
                deleteAllTodos();
              },
              child: Text('Sim'))
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
