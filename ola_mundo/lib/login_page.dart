import 'package:flutter/material.dart';
import 'package:ola_mundo/home_page.dart';

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
                  if(email == 'email@email.com' && password == '123456') {
                    // Rotas Manuais
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage())); // Cria a nova tela por cima da tela atual
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage())); // Cria a nova tela e destrói tela atual
                  
                    // Rotas Automáticas
                    // Navigator.of(context).pushNamed('/home'); // Cria nova tela sobrepondo
                    Navigator.of(context).pushReplacementNamed('/home'); // Cria nova tela e destroi tela atual
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