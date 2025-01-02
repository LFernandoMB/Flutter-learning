import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(AppWidget(
    title: 'Hello World!',
  ));
}

class AppWidget extends StatelessWidget {
  final String title; // Criando titulo

  const AppWidget({super.key, required this.title}); // Construtor 
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }

}

class HomePageState extends State<HomePage> {
  int counter = 0;

  @override
  Widget build(Object context) {
    return Container(
        child: Center(
          child: GestureDetector(
            child: Text("Contador: $counter"), 
            onTap: (){
              setState(() {
                counter++;
              });
            },
          )),
      );
  }
}