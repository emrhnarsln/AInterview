import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/interview_provider.dart';
import 'result_screen.dart';
import '../models/question_answer.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Giriş yapılmamış.')));
    }

    final historyRef = FirebaseFirestore.instance
        .collection('interviews')
        .doc(user.uid)
        .collection('history')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Geçmiş Mülakatlar')),
      body: StreamBuilder<QuerySnapshot>(
        stream: historyRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError && !snapshot.hasData) {
            return const Center(
              child: Text('Hata oluştu. (Yetki veya bağlantı hatası)'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Henüz mülakat geçmişi yok.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              try {
                final qa = QuestionAnswer(
                  question: data['question'] ?? '',
                  userAnswer: data['answer'] ?? '',
                  aiIdealAnswer: data['ai_ideal_answer'] ?? '',
                );

                final timestamp = (data['timestamp'] as Timestamp?)?.toDate();

                return Card(
                  child: ListTile(
                    title: Text('Mülakat ${index + 1}'),
                    subtitle: Text(
                      timestamp?.toLocal().toString().split('.')[0] ?? '',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.read<InterviewProvider>().loadFromHistory([qa]);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ResultScreen()),
                      );
                    },
                  ),
                );
              } catch (e) {
                debugPrint("Firestore parse hatası: $e");
                return const SizedBox();
              }
            },
          );
        },
      ),
    );
  }
}
