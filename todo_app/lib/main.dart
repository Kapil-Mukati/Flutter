import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/widgets/edittodolist.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

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

class Todo {
  String text;
  int price;
  DateTime createdAt;
  DateTime? updatedAt;

  Todo({
    required this.text,
    required this.price,
    required this.createdAt,
    updatedAt,
  });

  //converting todo object into map<String, dynamic>..
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'price': price,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // type cast
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      text: map['text'],
      price: map['price'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  static String encode(List<Todo> todos) => json
      .encode(todos.map<Map<String, dynamic>>((todo) => todo.toMap()).toList());

  static List<Todo> decode(String todos) =>
      (json.decode(todos) as List<dynamic>)
          .map<Todo>((item) => Todo.fromMap(item))
          .toList();
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final todoController = TextEditingController();
  final priceController = TextEditingController();
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      todos = Todo.decode(prefs.getString('todos') ?? '[]');
    });
  }

  void addTodo() async {
    final String text = todoController.text.trim();
    final String priceText = priceController.text.trim();
    if (text.isEmpty) return;

    final int price = int.tryParse(priceText) ?? 0;

    final newTodo = Todo(
      text: text,
      price: price,
      createdAt: DateTime.now(),
    );

    // print(newTodo);
    // print(todos[0].price);
    setState(() {
      todos.add(newTodo);
      todoController.clear();
      priceController.clear();
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('todos', Todo.encode(todos));
  }

  void removeTodoWithConfirmation(int index) async {
    bool result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Todo'),
              content: const Text("Are you sure to delete this"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('cancel')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                      // removeTodo(index);
                    },
                    child: const Text('delete')),
              ],
            );
          },
        ) ??
        false;
    if (result) {
      removeTodo(index);
    }
  }

  void removeTodo(int index) async {
    Todo removedTodo = todos[index];
    setState(() {
      todos.removeAt(index);
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('todos', Todo.encode(todos));

    final message = SnackBar(
      content: const Text(
        'Todo deleted Successfully',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, shadows: [
          Shadow(
            color: Color.fromARGB(90, 0, 0, 0),
            blurRadius: 4,
          ),
        ]),
      ),
      backgroundColor: const Color.fromARGB(255, 166, 163, 163),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Undo',
        textColor: Colors.blue,
        onPressed: () {
          setState(() {
            todos.insert(index, removedTodo);
          });

          prefs.setString('todos', Todo.encode(todos));
        },
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(message);
  }

  void editTodo(int index) async {
    // print("todo[index].text: ");
    // print(todos[index].text);
    final editedText = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Edittodolist(
          todo: todos[index].text,
          price: todos[index].price,
        ),
      ),
    );

    if (editedText != null && editedText is Map<String, dynamic>) {
      setState(() {
        todos[index].text = editedText['updatedTodo'];
        todos[index].price = editedText['updatePrice'];
        todos[index].updatedAt = DateTime.now();
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('todos', Todo.encode(todos));
    }
  }

  String formatTime(DateTime dateTime) {
    final DateFormat timeFormatter = DateFormat('HH:mm:ss');
    return timeFormatter.format(dateTime);
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat dateFormatter = DateFormat('dd-MM-yyyy HH:mm:ss');
    return dateFormatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    List<Todo> reversedTodo = todos.reversed.toList();

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
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: priceController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter price',
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
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(reversedTodo[index].text),
                            const SizedBox(height: 4),
                            Text(
                              'Price: \$${reversedTodo[index].price}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Created: ${formatDateTime(reversedTodo[index].createdAt)}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            if (reversedTodo[index].updatedAt != null)
                              Text(
                                'LastUpdated: ${formatDateTime(reversedTodo[index].updatedAt!)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  editTodo(todos.length - 1 - index),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () => removeTodoWithConfirmation(
                                  todos.length - 1 - index),
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
