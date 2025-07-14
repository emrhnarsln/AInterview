import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/interview/screens/result_screen.dart';
import '../../../providers/interview_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class InterviewScreen extends StatefulWidget {
  final String area;
  final String level;

  const InterviewScreen({required this.area, required this.level, super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final TextEditingController _answerController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _localeId = 'en_US';

  void _initSpeech() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize();

    if (available) {
      var locales = await _speech.locales();
      for (var locale in locales) {
        debugPrint('Desteklenen dil: ${locale.localeId}');
      }

      var turkish = locales.firstWhere(
        (locale) => locale.localeId == 'tr_TR',
        orElse: () => locales.first,
      );

      setState(() {
        _localeId = turkish.localeId;
      });
    } else {
      debugPrint("Konuşma tanıma desteklenmiyor");
    }
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    Future.microtask(() {
      final provider = context.read<InterviewProvider>();
      provider.resetInterview();
      provider.loadNextQuestion(widget.area, widget.level);
    });
  }

  Future<void> _submitAnswer() async {
    final provider = context.read<InterviewProvider>();
    final answer = _answerController.text.trim();
    if (answer.isEmpty) return;

    await provider.submitAnswer(answer);

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

  void _toggleRecording() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => debugPrint('Mic Status: $status'),
        onError: (error) => debugPrint('Mic Error: $error'),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _answerController.text = val.recognizedWords;
            });
          },
          listenFor: const Duration(seconds: 10),
          pauseFor: const Duration(seconds: 3),
          localeId: _localeId,
          partialResults: true,
        );
      } else {
        debugPrint("Speech recognition not available");
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Soru:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(provider.currentQuestion),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _answerController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Cevabınızı yazın...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                      onPressed: _toggleRecording,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _submitAnswer,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Sonraki'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
