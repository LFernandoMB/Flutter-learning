import 'package:flutter/material.dart';
import 'package:ola_mundo/app_controller.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int counter = 0;
  // String definition = "Null";

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        backgroundColor: Color.fromARGB(236, 226, 213, 31),
        actions: [
          LoginSwitch()
          ],
      ),
      body: Container(
        width: double.infinity, // Faz o componente ocupar toda dimensão horizontalmente
        height: double.infinity, // Faz o componente ocupar toda dimensão verticalmente
        child: Column( // Componente que cria o Scroll
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza o componente em x e y
          // crossAxisAlignment: CrossAxisAlignment.start,
          // scrollDirection: Axis.horizontal, // Alinhando os componentes na direção horizontal

          children: [
            Text('Contador: $counter'),
            Container(height: 25),
            CustomSwitch(),
            Container(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Espaçamento entre os componentes equivalente
              // mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaçamento entre os componentes começando pelas bordas
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espaçamento maior entre os componentes
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.blue,
                ),
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.white,
                ),
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.red,
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // AppController.instance.changeTheme();

          setState(() {
                counter++;
              });
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

class LoginSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
          onPressed: () {
            // Rotas manuais
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage())); // Cria nova tela sobrepondo
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage())); // Cria nova tela e destroi tela atual
            
            // Rotas Automáticas
            // Navigator.of(context).pushNamed('/'); // Cria nova tela sobrepondo
            Navigator.of(context).pushReplacementNamed('/'); // Cria nova tela e destroi tela atual
          },
          child: Text('Login')
        );
    }
}