# Flutter-learning
Learning Flutter language

# Referencia
- Flutterando: [Playlist](https://www.youtube.com/watch?v=XeUiJJN0vsE&list=PLlBnICoI-g-d-J57QIz6Tx5xtUDGQdBFB&index=1)

# Estrutura e funcionamento
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

### Flutter commands (CMD and shortcuts)
- flutter doctor - Sugere melhorias de instalação
- flutter create <ola_mundo> - Criando um projeto chamado "ola_mundo" (O Flutter não aceita "-" no nome de arquivo)
- flutter run - Rodar esse comando na root
- stl + enter : Criando estruturas stateless
- stf + enter : Criando estruturas statefull
- ctrl + shift + p >> flutter debug painting : Contorna os componentes para faciliar a visualização (Toggle para desligar)

# Composição e execução
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

# Stateless e Statefull
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

### Statefull
- Statefull - com estado,  é o método que pode ser alterado
- Diferente do stateless não implementa o build, implementa um estado e precisamos criar uma nova classe para esse estado
- Na classe state implementamos o build
- E para chamar o widget criado chamamos a classe pai do state (No exemplo a classe HomePage)
- Porque usar um statefull? Porque podemos alterar coisas durante a execução do app diferente do stateless
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
```
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

# Organização e separação em arquivos
- Organizando as classes em arquivos
- app_widget.dart
```
import 'package:flutter/material.dart';
import 'home_page.dart';

class AppWidget extends StatelessWidget {
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
```
- home_page.dart
```
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
```
- main.dart
```
import 'package:flutter/material.dart';

import 'app_widget.dart';

void main(List<String> args) {
  runApp(AppWidget(
  ));
}

```

# Renderização de Tela - Single Render e Multi Render
- Os conceitos de single render e multi render no Flutter estão diretamente relacionados à forma como os widgets são construídos e renderizados na tela
- Filhos acabam herdando características de seus pais, apenas um Render para executar as características
- Para conseguir utilizar características diferentes é necessário atribuir o widget à um SingleRender
- SingleRender irá criar um novo render

Os conceitos de single render e multi render no Flutter estão diretamente relacionados à forma como os widgets são construídos e renderizados na tela. Essa compreensão é fundamental para otimizar o desempenho de suas aplicações Flutter e criar interfaces de usuário mais eficientes.

Single Render
* O que é: Quando um widget é marcado como tendo um único filho (single-child), ele significa que esse widget só pode conter um único elemento filho dentro de sua estrutura.
* Exemplo: Um Container é um exemplo clássico de widget que aceita apenas um filho. Você pode colocar um Text, um Image ou outro widget dentro dele, mas não vários diretamente.
* Vantagens:
  * Simplicidade: A estrutura do widget fica mais clara e organizada.
  * Performance: Em alguns casos, o Flutter pode otimizar a renderização de widgets com um único filho.

Multi Render
* O que é: Widgets que aceitam múltiplos filhos (multi-child) podem conter vários elementos filhos dentro de sua estrutura.
* Exemplo: Um Row ou um Column são exemplos de widgets que aceitam múltiplos filhos. Você pode colocar vários Text, Icon e outros widgets dentro deles para criar layouts mais complexos.
* Vantagens:
Flexibilidade: Permite criar layouts mais complexos e personalizados.
Reutilização: Widgets como Row e Column são muito úteis para criar layouts responsivos e adaptáveis.

Quando usar cada um?
* Single Render:
Quando você precisa de um container simples para um único elemento.
Quando a performance é crítica e você quer evitar renderizações desnecessárias.
* Multi Render:
Quando você precisa criar layouts mais complexos com múltiplos elementos.
Quando você precisa criar layouts responsivos e adaptáveis.

### A importância do State e da Renderização
* State: O estado de um widget define como ele é exibido na tela. Quando o estado muda, o widget é reconstruído e a tela é atualizada.
* Renderização: A renderização é o processo de criar a representação visual de um widget na tela.

Ao entender esses conceitos, você pode:
* Otimizar o desempenho: Evitando reconstruções desnecessárias de widgets.
* Criar interfaces de usuário mais complexas: Utilizando widgets que aceitam múltiplos filhos.
* Escrever código mais limpo e organizado: Utilizando a estrutura correta de widgets para cada situação.

```
// Single Render
Container(
  color: Colors.blue,
  child: Text('Olá, mundo!'),
)

// Multi Render
Row(
  children: [
    Icon(Icons.home),
    Text('Home'),
  ],
)
```

# Debug
- Inserir breakpoint na lateral esquerda da parte de código da IDE
- Quando estiver em modo Debug ele irá pausar no breakpoint inserido
- Com isso podemos ver qual valor de variáveis e analisar o estado atual da aplicação
- Podemos verificar valores, pegar certificados e várias outras ações