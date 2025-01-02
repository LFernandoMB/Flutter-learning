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
    return Container(
        child: Center(
          child: GestureDetector(
            child: Text("$counter é $definition"), 
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
      );
  }
}