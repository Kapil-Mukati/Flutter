import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/widgets/edittodolist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final todoController = TextEditingController();
  List<String> todos = [];

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      todos = prefs.getStringList('todos') ?? [];
    });
  }

  void addTodo() async {
    final String text = todoController.text;
    if (text.isEmpty) return;
    setState(() {
      todos.add(text);
      todoController.clear();
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('todos', todos);
  }

  void removeTodo(int index) async {
    setState(() {
      todos.removeAt(index);
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('todos', todos);
  }

  void editTodo(int index) async {
    final editedText = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Edittodolist(todo: todos[index]),
      ),
    );

    if (editedText != null && editedText is Map<String, dynamic>) {
      setState(() {
        todos[index] = editedText['updatedTodo'];
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('todos', todos);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> reversedTodo = todos.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title: const Text(
          'TodoApp',
          style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.grey,
                  blurRadius: 10,
                  offset: Offset(5, 5),
                )
              ]),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(175, 158, 158, 158),
                        blurRadius: 2,
                        // spreadRadius: 1,
                        offset: Offset(2, 2),
                      ),
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter a task',
                        ),
                      ),
                    ),
                    IconButton(onPressed: addTodo, icon: const Icon(Icons.add))
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Text(reversedTodo[index]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  editTodo(todos.length - 1 - index),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () =>
                                  removeTodo(todos.length - 1 - index),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
