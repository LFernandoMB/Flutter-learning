
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(Container(
    child: Center(
      child: Text(
        'Hello World!', 
        textDirection: TextDirection.ltr,
        style: TextStyle(color: Colors.white, fontSize: 50.0),
      ),
    ),
  ));
}