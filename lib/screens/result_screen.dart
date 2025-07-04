import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/interview_session.dart';
import '../services/gemini_service.dart';

class ResultScreen extends StatefulWidget {
  final List<QuestionAnswer> qaList;

  const ResultScreen({required this.qaList, super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late List<String> aiAnswers;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAIResponsesAndSave();
  }

  Future<void> _loadAIResponsesAndSave() async {
    final gemini = GeminiService();
    final results = await gemini.evaluateMultipleAnswers(widget.qaList);

    // 🧠 Geçmiş kaydı için AI yanıtları ile birleşik QA listesi oluştur
    final fullQAList = List.generate(widget.qaList.length, (i) {
      return QuestionAnswer(
        question: widget.qaList[i].question,
        userAnswer: widget.qaList[i].userAnswer,
        aiIdealAnswer: results[i],
      );
    });

    // 💾 Hive veritabanına oturumu kaydet
    final box = Hive.box<InterviewSession>('sessions');
    final session = InterviewSession(
      date: DateTime.now(),
      qaList: fullQAList,
    );
    await box.add(session);

    setState(() {
      aiAnswers = results;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toplu Geri Bildirim')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.qaList.length,
        itemBuilder: (context, index) {
          final qa = widget.qaList[index];
          final ideal = aiAnswers[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Soru ${index + 1}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(qa.question),
                  const SizedBox(height: 12),
                  const Text('Senin Cevabın:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(qa.userAnswer),
                  const SizedBox(height: 12),
                  const Text('AI Örnek Cevap:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(ideal),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
