import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/question_answer.dart';
import '../models/interview_session.dart';
import '../services/firestore_service.dart';

class ResultScreen extends StatefulWidget {
  final List<QuestionAnswer> qaList;
  final bool save;
  const ResultScreen({super.key, required this.qaList, this.save = true});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.save) {
      _saveSession();
    }
  }

  Future<void> _saveSession() async {
    final user = FirebaseAuth.instance.currentUser;
    //if (user == null) return;

    final session = InterviewSession(
      id: '',
      userId: user?.uid ?? 'test-user',
      timestamp: DateTime.now(),
      answers: widget.qaList,
    );

    await FirestoreService().saveInterviewSession(session);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mülakat Sonucu')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.qaList.length,
        itemBuilder: (context, index) {
          final qa = widget.qaList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(qa.question),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Senin cevabın: ${qa.userAnswer}'),
                  const SizedBox(height: 8),
                  Text('AI cevabı: ${qa.aiIdealAnswer}'),
                  const SizedBox(height: 8),
                  Text('DATE: ${DateTime.now().toIso8601String()}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
