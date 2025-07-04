import 'package:flutter/material.dart';
import '../models/interview_session.dart';

class InterviewDetailScreen extends StatelessWidget {
  final InterviewSession session;

  const InterviewDetailScreen({required this.session, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mülakat Detayı'),
            Text(
              'Tarih: ${session.date.toLocal().toString().split('.')[0]}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: session.qaList.length,
        itemBuilder: (context, index) {
          final qa = session.qaList[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Soru ${index + 1}',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(qa.question),
                  const SizedBox(height: 12),
                  const Text('Senin Cevabın:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(qa.userAnswer),
                  const SizedBox(height: 12),
                  const Text('AI Örnek Cevap:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(qa.aiIdealAnswer),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
