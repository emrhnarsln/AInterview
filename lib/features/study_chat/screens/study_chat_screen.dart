import 'dart:io';
import 'package:flutter/material.dart';
import 'package:interview_with_ai/core/services/gemini_service.dart';
import 'package:interview_with_ai/core/services/audio_recorder_service.dart';
import 'package:interview_with_ai/core/services/whisper_service.dart';
import 'package:provider/provider.dart';
import 'package:interview_with_ai/providers/tts_provider.dart';

class StudyChatScreen extends StatefulWidget {
  const StudyChatScreen({super.key});

  @override
  State<StudyChatScreen> createState() => _StudyChatScreenState();
}

class _StudyChatScreenState extends State<StudyChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool isLoading = false;
  bool _isRecording = false;

  final _recorder = AudioRecorderService();
  final _whisper = WhisperService();

  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    context.read<TtsProvider>().stop();
    super.dispose();
  }

  void _sendMessage(String input) async {
    if (input.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'content': input});
      isLoading = true;
    });

    final gemini = GeminiService();

    final response = await gemini.generateContent(
      prompt:
          '''
Sen sosyal, arkadaş canlısı ve samimi hem teknik hem de insak kaynakları mülakatlarında uzmanlaşmış bir yapay zeka asistanısın. Kullanıcı seninle uygulama içerisinde mülakat pratiği yapmak istiyor. Cevabını:

-Sanki bir işe alım uzmanı gibi ver.
-Emoji kullanma.
-Kullanıcıyla hem teknik hem de genel anlamda  iletişime geç.

Kullanıcının mesajı:
$input
''',
    );

    setState(() {
      messages.add({'role': 'ai', 'content': response});
      isLoading = false;
    });

    final ttsBytes = await context.read<TtsProvider>().speak(response);
    if (ttsBytes != null) {
      // Ses oynatma zaten TtsProvider içinde gerçekleşiyor
    }
  }

  Future<void> _startVoiceChat() async {
    setState(() => _isRecording = true);
    _animController.forward();

    try {
      final path = await _recorder.startRecording();
      await Future.delayed(const Duration(seconds: 4));
      await _recorder.stopRecording();

      final transcript = await _whisper.transcribeAudio(File(path));

      if (transcript.isEmpty || transcript.trim().length < 5) {
        debugPrint("⛔ Geçersiz transkript: '$transcript'");
        setState(() => _isRecording = false);
        _animController.reverse();
        return;
      }

      final ignoredPhrases = ["...", ""];
      if (ignoredPhrases.contains(transcript.trim().toLowerCase())) {
        debugPrint("⛔ Anlamsız transkript engellendi: '$transcript'");
        setState(() => _isRecording = false);
        _animController.reverse();
        return;
      }

      _controller.text = transcript;
      _sendMessage(transcript);
    } catch (e) {
      debugPrint("🎙️ Sesli sohbet hatası: $e");
    } finally {
      setState(() => _isRecording = false);
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI ile Konu Çalış')),
      body: Column(
        children: [
          if (messages.isEmpty)
            Expanded(
              child: Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: IconButton(
                    iconSize: 80,
                    color: _isRecording ? Colors.red : Colors.indigo,
                    icon: Icon(_isRecording ? Icons.stop_circle : Icons.mic),
                    onPressed: _isRecording ? null : _startVoiceChat,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[messages.length - 1 - index];
                  final isUser = msg['role'] == 'user';

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 300),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.indigo[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(msg['content'] ?? ''),
                    ),
                  );
                },
              ),
            ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: CircularProgressIndicator(),
            ),
          if (messages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isRecording ? Icons.stop_circle : Icons.mic,
                      color: _isRecording ? Colors.red : Colors.indigo,
                    ),
                    tooltip: _isRecording ? 'Kaydı Durdur' : 'Sesli Mesaj',
                    onPressed: _isRecording ? null : _startVoiceChat,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Bir konu veya soru yaz...',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final input = _controller.text.trim();
                      if (input.isNotEmpty) {
                        _controller.clear();
                        _sendMessage(input);
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
