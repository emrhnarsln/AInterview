import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../models/interview_session.dart';
import 'result_screen.dart';


class InterviewScreen extends StatefulWidget {
  final String area;
  final String level;


  const InterviewScreen({
    required this.area,
    required this.level,
    super.key,
  });

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final TextEditingController _answerController = TextEditingController();

  final List<QuestionAnswer> qaList = [];
  String currentQuestion = '';
  int questionIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNextQuestion();
  }

  Set<String> previousQuestions = {};

  Future<void> _loadNextQuestion() async {
    setState(() => isLoading = true);
    final gemini = GeminiService();

    String newQuestion = '';
    int attempts = 0;

    do {
      newQuestion = await gemini.generateQuestion(
        area: widget.area,
        level: widget.level,
      );
      attempts++;
    } while (previousQuestions.contains(newQuestion) && attempts < 5);

    previousQuestions.add(newQuestion);

    setState(() {
      currentQuestion = newQuestion;
      _answerController.clear();
      isLoading = false;
    });
  }


  void _submitAnswer() {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) return;

    qaList.add(QuestionAnswer(question: currentQuestion, userAnswer: answer, aiIdealAnswer: ''));

    if (qaList.length == 5) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(qaList: qaList),
        ),
      );
    } else {
      _loadNextQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soru ${qaList.length + 1} / 5'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Soru:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(currentQuestion),
              const SizedBox(height: 24),
              TextField(
                controller: _answerController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Cevabınızı yazın...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _submitAnswer,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Sonraki'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
