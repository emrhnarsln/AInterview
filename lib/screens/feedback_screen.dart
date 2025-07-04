import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class FeedbackScreen extends StatefulWidget {
  final String question;
  final String userAnswer;

  const FeedbackScreen({
    required this.question,
    required this.userAnswer,
    super.key,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String feedback = 'Yapay zeka geri bildirimi yükleniyor...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAIResponse();
  }

  Future<void> _getAIResponse() async {
    final gemini = GeminiService();
    final result = await gemini.evaluateAnswer(
      question: widget.question,
      userAnswer: widget.userAnswer,
    );

    setState(() {
      feedback = result;
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Geri Bildirim')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // 👈 SCROLL EKLENDİ
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Soru:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.question),
              const SizedBox(height: 16),
              const Text('Senin Cevabın:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.userAnswer),
              const SizedBox(height: 16),
              const Text(
                  'AI Yorum:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(feedback),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('Ana Sayfaya Dön'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
