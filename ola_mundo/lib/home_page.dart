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
      body: Center(
          child: GestureDetector(
            child: Text(
              "$counter é $definition",
              style: TextStyle(fontSize: 30.0),
            ), 
            onTap: (){
              setState(() {
                counter++;
                if (counter%2==0) {
                  definition = "Par";
                } else {
                  definition = "Ímpar";
                }
              });
            },
          )
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