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
    return Container(
    child: Center(
      child: Text(
        title, 
        textDirection: TextDirection.ltr,
        style: TextStyle(color: Colors.white, fontSize: 50.0),
      ),
    ),
  );
  }
}