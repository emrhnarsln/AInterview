import 'package:flutter/material.dart';
import '../../../core/services/gemini_service.dart';

class StudyChatScreen extends StatefulWidget {
  const StudyChatScreen({super.key});

  @override
  State<StudyChatScreen> createState() => _StudyChatScreenState();
}

class _StudyChatScreenState extends State<StudyChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages =
      []; // {role: user/ai, content: message}
  bool isLoading = false;

  void _sendMessage() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'content': input});
      isLoading = true;
      _controller.clear();
    });

    final gemini = GeminiService();

    final response = await gemini.generateContent(
      prompt:
          'Kullanıcı aşağıdaki konuda çalışmak istiyor veya soru soruyor. Açık ve kısa anlat:\n\n"$input"',
    );

    setState(() {
      messages.add({'role': 'ai', 'content': response});
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI ile Konu Çalış')),
      body: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Bir konu veya soru yaz...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
