import 'package:flutter/material.dart';
import 'package:ola_mundo/app_controller.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  // int counter = 0;
  // String definition = "Null";

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        backgroundColor: Color.fromARGB(236, 226, 213, 31),
        actions: [
          CustomSwitch()
          ],
      ),
      body: Center(
        child: CustomSwitch(),
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          AppController.instance.changeTheme();

          // setState(() {
          //       counter++;
          //       if (counter%2==0) {
          //         definition = "Par";
          //       } else {
          //         definition = "Ímpar";
          //       }
          //     });
        }),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Switch(
          value: AppController.instance.isDarkTheme, 
          onChanged: (value) {
            AppController.instance.changeTheme();
          });
  }
}