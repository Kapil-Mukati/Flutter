import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Page",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * .15,
          width: MediaQuery.of(context).size.width * .35,
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Center(
            child: Text(
              "Hello!! Home123..",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: Offset(5, 5),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
