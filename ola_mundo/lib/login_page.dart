import 'package:flutter/material.dart';

import 'app_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder()
                  ),
                  onChanged: (text) {
                    email = text;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder()
                  ),
                  onChanged: (text) {
                    password = text;
                  },
                ),
                SizedBox(height: 15),
                TextButton(onPressed: () {
                  if(email == 'l.fernandomb7@gmail.com' && password == '123456') {
                    AppController.instance.changeTheme();
                  }
                }, 
                child: Text('Entrar'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}