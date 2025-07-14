import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/interview_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InterviewProvider>();
    final qaList = provider.qaList;

    return Scaffold(
      appBar: AppBar(title: const Text('Mülakat Sonuçları')),
      body: qaList.isEmpty
          ? const Center(child: Text('Sonuç bulunamadı.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: qaList.length,
              itemBuilder: (context, index) {
                final qa = qaList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Soru ${index + 1}:',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(qa.question),
                        const Divider(),
                        Text(
                          'Senin Cevabın:',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(qa.userAnswer),
                        const Divider(),
                        Text(
                          'Yapay Zekadan Geri Bildirim:',
                          style: TextStyle(color: Colors.green[800]),
                        ),
                        const SizedBox(height: 4),
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
