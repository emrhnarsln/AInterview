import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../features/interview/screens/result_screen.dart';
import '../../../providers/interview_provider.dart';
import '../../../core/services/audio_recorder_service.dart';
import '../../../core/services/whisper_service.dart';

class InterviewScreen extends StatefulWidget {
  final String area;
  final String level;

  const InterviewScreen({required this.area, required this.level, super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final TextEditingController _answerController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  final _recorder = AudioRecorderService();
  final _whisperService = WhisperService();

  bool _isRecording = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final provider = context.read<InterviewProvider>();
      provider.resetInterview();
      provider.loadNextQuestion(widget.area, widget.level);
    });
  }

  Future<void> _startAudioRecording() async {
    try {
      await _recorder.startRecording();
      setState(() => _isRecording = true);
      debugPrint("🎤 Kayıt başladı");
    } catch (e) {
      debugPrint("⚠️ Mikrofon izni alınamadı veya hata: $e");
    }
  }

  Future<void> _stopAudioRecording() async {
    final path = await _recorder.stopRecording();
    setState(() => _isRecording = false);

    if (path == null) {
      debugPrint("⚠️ Kayıt durdurulamadı.");
      return;
    }

    final file = File(path);
    if (await file.exists()) {
      final size = await file.length();
      debugPrint("📁 Dosya boyutu: $size bytes");

      if (size > 1000) {
        final transcript = await _whisperService.sendAudioToWhisper(path);

        if (transcript != null && transcript.isNotEmpty) {
          setState(() {
            _answerController.text = transcript;
          });
          debugPrint("📄 Whisper Transkript: $transcript");
        } else {
          debugPrint("⚠️ Whisper boş transkript döndü.");
        }
      } else {
        debugPrint("⚠️ Dosya çok küçük, geçersiz kayıt.");
      }
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("tr-TR");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(text);
  }

  Future<void> _submitAnswer() async {
    final provider = context.read<InterviewProvider>();
    final answer = _answerController.text.trim();
    if (answer.isEmpty) return;

    await provider.submitAnswer(answer);

    final aiIdeal = provider.qaList.last.aiIdealAnswer;
    if (aiIdeal.isNotEmpty) await _speak(aiIdeal);

    if (!mounted) return;

    if (provider.qaList.length == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    } else {
      _answerController.clear();
      await provider.loadNextQuestion(widget.area, widget.level);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InterviewProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Soru ${provider.questionIndex + 1} / 1')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Soru:', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(provider.currentQuestion),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _answerController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Cevabınızı yazın veya konuşun...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isRecording
                              ? Icons.stop_circle
                              : Icons.fiber_manual_record,
                          color: _isRecording ? Colors.red : Colors.black,
                        ),
                        tooltip: _isRecording
                            ? 'Kaydı durdur'
                            : 'Ses kaydet (Whisper)',
                        onPressed: () async {
                          if (_isRecording) {
                            await _stopAudioRecording();
                          } else {
                            await _startAudioRecording();
                          }
                        },
                      ),
                      ElevatedButton.icon(
                        onPressed: _submitAnswer,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Sonraki'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
