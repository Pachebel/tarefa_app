# tarefapp 
 **This is just a simple to do APP**, no big deal

# app images
## icon
![WhatsApp Image 2022-03-13 at 15 24 23](https://user-images.githubusercontent.com/89677437/158074711-6cade513-24a6-46b6-a176-bea7ba8da659.jpeg)
## pages
![WhatsApp Image 2022-03-13 at 15 24 25 (3)](https://user-images.githubusercontent.com/89677437/158074718-eeb9eafe-9537-4510-966e-da910c689bc9.jpeg)

![WhatsApp Image 2022-03-13 at 15 24 25 (2)](https://user-images.githubusercontent.com/89677437/158074728-1d6d84b5-3322-4a59-af1d-b8fc5f0b3a01.jpeg)

![WhatsApp Image 2022-03-13 at 15 24 25 (1)](https://user-images.githubusercontent.com/89677437/158074733-25d6cdad-fe5d-4509-bc3e-b0372a0c8fd4.jpeg)

![WhatsApp Image 2022-03-13 at 15 24 24 (1)](https://user-images.githubusercontent.com/89677437/158074737-226ae362-10db-40de-8904-6d7b4fc3f6bb.jpeg)

![WhatsApp Image 2022-03-13 at 15 24 24](https://user-images.githubusercontent.com/89677437/158074747-f1a8448d-cc16-4238-a352-ed17a41d12a8.jpeg)



# main.dart

```

import 'package:flutter/material.dart';
import 'package:tarefapp/pages/todo_list_page.dart';
void main(){
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListPage(),

    );
  }
}

```

# todo_list_item.dart

```
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

```

# todo_list_page.dart

```

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

```

# pubspec.yaml

```

name: tarefapp
description: opa

# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number used as CFBundleVersion.
# Read more about iOS versioning at![WhatsApp Image 2022-03-13 at 15 24 23](https://user-images.githubusercontent.com/89677437/158073789-51cc570a-8a7a-4298-b50c-d69320292c81.jpeg)

# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
version: 1.0.0+1

environment:
  sdk: ">=2.16.1 <3.0.0"

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter





  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2
  intl: ^0.17.0
  flutter_slidable: ^1.2.0
  shared_preferences: ^2.0.13
  flutter_launcher_icons: ^0.9.2



dev_dependencies:
  flutter_app_name: ^0.1.1
flutter_app_name:
  name: "TarefAPP"


  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^1.0.0

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true
  assets:
    - lib/assets/icon/icon.png

flutter_icons:
  android: true
  ios: true
  image_path: "lib/assets/icon/icon.png"

  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/assets-and-images/#resolution-aware.

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/assets-and-images/#from-packages

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/custom-fonts/#from-packages
  
```
