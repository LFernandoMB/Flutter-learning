import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }

}

class HomePageState extends State<HomePage> {
  int counter = 0;
  String definition = "Null";

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        backgroundColor: Color.fromARGB(236, 226, 213, 31),
      ),
      body: Container(
        height: 200,
        width: 200,
        color: Colors.black,
        child: Center(
          child: Container(
            height: 100,
            width: 100,
            color: Colors.green,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
                counter++;
                if (counter%2==0) {
                  definition = "Par";
                } else {
                  definition = "Ímpar";
                }
              });
        }),
    );
  }
}