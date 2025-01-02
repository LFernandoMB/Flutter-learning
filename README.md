# Flutter-learning
Learning Flutter language

# Referencia
- Flutterando: [Playlist](https://www.youtube.com/watch?v=XeUiJJN0vsE&list=PLlBnICoI-g-d-J57QIz6Tx5xtUDGQdBFB&index=1)

# Aula 01
- Flutter é um framework feito em Dart
- Utiliza uma estrutura declarativa e POO
- pubspec.yaml - Gerenciador de pacotes

### Instalação
- [Download flutter](https://docs.flutter.dev/get-started/install/windows/web)

- [Ambiente de programação em Dart Online](https://dart.dev/#try-dart)

- [Dart Book](https://dart.dev/language)

- Plataformas Mobile: AndroidStudio (Android) - Xcode (IOS) - Build para a plataforma

- IDE (Visual Studio Code)
    - Pluggin: Flutter (dart-code.flutter)

### Flutter commands (CMD)
- flutter doctor - Sugere melhorias de instalação
- flutter create <ola_mundo> - Criando um projeto chamado "ola_mundo" (O Flutter não aceita "-" no nome de arquivo)
- flutter run - Rodar esse comando na root

# Aula 02
- Flutter trabalha com orientação a objeto
- Nas classes criadas sempre precisamos ter o método builder, pois esse método trás oque é necessário para o Skia desenhar na tela
- Hot Reload - Atualiza o app rodando conforme são feitas as alterações
- Widget: Componente

### Código básico para um projeto em Flutter
```
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(Container());
}
```

- Trabalharemos sempre com Widgets
- No exemplo abaixo escrevemos um texto centralizado com tamanho 50.0

```
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
```

# Aula 03
- Estado Global e Local
- Stateless (Sem estado) - Statefull (Com estado)

### Stateless
- Não tem alteração a não ser que o método pai o reconstrua
- Criamos uma classe que extende de StatelessWidget
- Implementamos o método build (Como QuickFix)
- Retornamos no método oque desejamos criar

```
class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
    child: Center(
      child: Text(
        'Hello World!', 
        textDirection: TextDirection.ltr,
        style: TextStyle(color: Colors.white, fontSize: 50.0),
      ),
    ),
  );
  }
}
```

- Chamamos a classe

```
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
    child: Center(
      child: Text(
        'Hello World!', 
        textDirection: TextDirection.ltr,
        style: TextStyle(color: Colors.white, fontSize: 50.0),
      ),
    ),
  );
  }
}
```

- Para o projeto ter funções e aparencia de aplicação podemos importar o MaterialApp
```
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
      home: Container(
        child: Center(child: Text(title)),
      ),
    );
  }
}
```

# Aula 04
- Statefull com estado é o método que pode ser alterado
- Diferente do stateless não implementa o build, implementa um estado e precisamos criar uma nova classe para esse estado
- Na classe state implementamos o build
- E para chamar o widget criado chamamos a classe pai do state (No exemplo a classe HomePage)
- Porque usar um statefull? Porque podemos alterar coisas durante a execução do app diferente do stateless
````
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
  @override
  Widget build(Object context) {
    return Container(
        child: Center(child: Text("Hello StateFull")),
      );
  }

}
```

- O estado só é modificado se inserirmos as modificações dentro de setState(() {// Aqui})
````
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
```