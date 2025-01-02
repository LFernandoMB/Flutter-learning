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