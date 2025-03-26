import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(SpellCheckApp());

class SpellCheckApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SpellCheckHome(),
    );
  }
}

class SpellCheckHome extends StatefulWidget {
  @override
  _SpellCheckHomeState createState() => _SpellCheckHomeState();
}

class _SpellCheckHomeState extends State<SpellCheckHome> {
  TextEditingController _controller = TextEditingController();
  List<dynamic> suggestions = [];
  Set<int> appliedSuggestions = {}; // NOVO: guarda os índices aplicados

  Future<void> checkSpelling() async {
    final url = Uri.parse('https://api.languagetool.org/v2/check');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'text': _controller.text,
        'language': 'pt-BR',
      },
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      List matches = result['matches'];

      setState(() {
        suggestions = matches;
        appliedSuggestions.clear(); // limpa quando faz nova verificação
      });
    } else {
      print('Erro na API');
    }
  }

  void applySuggestion(int index, int offset, int length, String replacement) {
    String newText = _controller.text;
    newText = newText.replaceRange(offset, offset + length, replacement);

    setState(() {
      _controller.text = newText;
      appliedSuggestions.add(index); // marca sugestão como aplicada
      // remove todas quando todas forem aplicadas
      if (appliedSuggestions.length == suggestions.length) {
        suggestions.clear();
        appliedSuggestions.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Correção Ortográfica')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu texto...',
              ),
            ),
            SizedBox(height: 20),
            suggestions.isNotEmpty
                ? Wrap(
                    spacing: 8.0,
                    children: List.generate(suggestions.length, (index) {
                      if (appliedSuggestions.contains(index)) {
                        // já corrigido, não mostra mais
                        return SizedBox();
                      }
                      var match = suggestions[index];
                      String firstReplacement = match['replacements'].isNotEmpty
                          ? match['replacements'][0]['value']
                          : '';

                      return ElevatedButton(
                        onPressed: () => applySuggestion(
                          index,
                          match['offset'],
                          match['length'],
                          firstReplacement,
                        ),
                        child: Text(firstReplacement),
                      );
                    }),
                  )
                : Text(''),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkSpelling,
              child: Text('Verificar Ortografia'),
            ),
          ],
        ),
      ),
    );
  }
}
