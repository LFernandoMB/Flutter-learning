import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();

  String? recordingPath;
  bool isRecording = false, isPlaying = false;
  String? transcription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _recordingButton(),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (recordingPath != null)
            Column(
              children: [
                MaterialButton(
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.stop();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await audioPlayer.setAudioSource(AudioSource.file(recordingPath!));
                      await audioPlayer.play();
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  color: Theme.of(context).colorScheme.primary,
                  child: Text(
                    isPlaying ? "Stop Playing Recording" : "Start Playing Recording",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  onPressed: () => _sendAudioForTranscription(),
                  color: Colors.blue,
                  child: const Text("Transcribe Audio", style: TextStyle(color: Colors.white)),
                ),
                if (transcription != null) ...[
                  const SizedBox(height: 10),
                  Text("Transcription: $transcription", textAlign: TextAlign.center),
                ],
              ],
            ),
          if (recordingPath == null)
            const Text("No Recording Found. :(")
        ],
      ),
    );
  }

  Widget _recordingButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (isRecording) {
          String? filePath = await audioRecorder.stop();
          if (filePath != null) {
            setState(() {
              isRecording = false;
              recordingPath = filePath;
            });
          }
        } else {
          if (await audioRecorder.hasPermission()) {
            final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
            final String filePath = p.join(appDocumentsDir.path, "recording.wav");

            setState(() {
              recordingPath = null;
            });

            await audioRecorder.start(
              const RecordConfig(
                encoder: AudioEncoder.wav,
                bitRate: 128000,
                sampleRate: 44100,
              ),
              path: filePath,
            );

            setState(() {
              isRecording = true;
            });
          }
        }
      },
      child: Icon(
        isRecording ? Icons.stop : Icons.mic,
      ),
    );
  }

  Future<void> _sendAudioForTranscription() async {
    if (recordingPath == null) return;

    var request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:5000/transcribe'));
    request.files.add(await http.MultipartFile.fromPath('audio', recordingPath!));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        setState(() {
          transcription = jsonResponse['transcription'];
        });
      } else {
        setState(() {
          transcription = "Error in transcription.";
        });
      }
    } catch (e) {
      setState(() {
        transcription = "Failed to connect to the API.";
      });
    }
  }
}
