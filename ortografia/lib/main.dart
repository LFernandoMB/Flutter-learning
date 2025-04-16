import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const SpellingApp());
}

class SpellingApp extends StatelessWidget {
  const SpellingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spelling Corrector',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SpellingHomePage(),
    );
  }
}

class SpellingHomePage extends StatefulWidget {
  const SpellingHomePage({super.key});

  @override
  State<SpellingHomePage> createState() => _SpellingHomePageState();
}

class _SpellingHomePageState extends State<SpellingHomePage> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendTextToApi() async {
    final String text = _controller.text;

    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    const String apiUrl = "http://127.0.0.1:5000/spelling";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"spelling": text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _controller.text = data['spelling'];
        });
      } else {
        print("Erro da API: ${response.body}");
      }
    } catch (e) {
      print("Erro na requisição: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Correção Ortográfica')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Digite o texto',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendTextToApi,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Corrigir Texto"),
            ),
          ],
        ),
      ),
    );
  }
}
