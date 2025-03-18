import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}): super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter InAppWebView")
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("http://127.0.0.1:8080"),
              ),
            ),
          )
        ],
      ),
    );
  }
}