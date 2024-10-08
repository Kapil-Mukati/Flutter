import 'package:flutter/material.dart';

class Edittodolist extends StatefulWidget {
  final String todo;
  final int price;
  const Edittodolist({super.key, required this.todo, required this.price});
  @override
  State<Edittodolist> createState() => _EdittodolistState();
}

class _EdittodolistState extends State<Edittodolist> {
  late TextEditingController textController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.todo);
    priceController = TextEditingController(text: widget.price.toString());
  }

  void saveTodo() {
    Navigator.pop(context, {
      'updatedTodo': textController.text,
      'updatePrice': int.tryParse(priceController.text) ?? 0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveTodo,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade200),
              child: const Text(
                'save',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        // offset:
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
