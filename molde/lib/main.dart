import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _userDataFolder;
  WebViewEnvironment? _webViewEnvironment;
  bool _envReady = false;
  String? _envError;

  @override
  void initState() {
    super.initState();
    _prepareEnvironment();
  }

  @override
  void dispose() {
    // Se criar WebViewEnvironment, dispose para liberar recursos nativos
    _disposeEnvironment();
    super.dispose();
  }

  Future<void> _disposeEnvironment() async {
    try {
      if (_webViewEnvironment != null) {
        await _webViewEnvironment!.dispose();
        _webViewEnvironment = null;
      }
    } catch (e) {
      // Ignorar erros no dispose
      debugPrint("Erro ao dar dispose em WebViewEnvironment: $e");
    }
  }

  Future<void> _prepareEnvironment() async {
    try {
      // Cria pasta de dados em LOCALAPPDATA (getApplicationSupportDirectory)
      final Directory supportDir = await getApplicationSupportDirectory();
      final String userDataPath = "${supportDir.path}${Platform.pathSeparator}WebView2";
      Directory(userDataPath).createSync(recursive: true);
      debugPrint("UserDataFolder criado: $userDataPath");

      // Atualiza estado do caminho
      setState(() {
        _userDataFolder = userDataPath;
      });

      // Cria (assincronamente) o WebViewEnvironment com as settings desejados
      final WebViewEnvironmentSettings settings = WebViewEnvironmentSettings(
        userDataFolder: _userDataFolder,
      );

      _webViewEnvironment = await WebViewEnvironment.create(settings: settings);

      debugPrint("WebViewEnvironment criado com id: ${_webViewEnvironment?.id}");

      setState(() {
        _envReady = true;
        _envError = null;
      });
    } catch (e, st) {
      debugPrint("Erro ao preparar WebViewEnvironment: $e\n$st");
      setState(() {
        _envReady = false;
        _envError = "Falha ao inicializar WebViewEnvironment: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_envReady) {
      return Scaffold(
        appBar: AppBar(title: const Text("Teste WebView2")),
        body: Center(
          child: _envError == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_envError!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        _prepareEnvironment();
                      },
                      child: const Text("Tentar novamente"),
                    ),
                  ],
                ),
        ),
      );
    }

    // Objeto webViewEnvironment para o InAppWebView
    return Scaffold(
      // appBar: AppBar(title: const Text("InAppWebView + MSIX safe userDataFolder")),
      body: Column(
        children: <Widget>[
          Expanded(
            child: InAppWebView(
              initialUrlRequest:
                  URLRequest(url: WebUri("http://localhost:9090/?pagina=previsao_ideb&id_usuario=1194")),
              initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
              webViewEnvironment: _webViewEnvironment,
              onWebViewCreated: (controller) {
                debugPrint("WebView criado (controller)");
              },
              onLoadStop: (controller, url) {
                debugPrint("Página carregada: $url");
              },
            ),
          ),
        ],
      ),
    );
  }
}
