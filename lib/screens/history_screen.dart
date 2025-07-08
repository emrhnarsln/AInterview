import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/interview_session.dart';
import 'result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Giriş yapılmamış.'));
    }

    final sessionsRef = FirebaseFirestore.instance
        .collection('interview_sessions')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Geçmiş Mülakatlar')),
      body: StreamBuilder<QuerySnapshot>(
        stream: sessionsRef.snapshots(),
        builder: (context, snapshot) {
          // 1. Hata varsa ve veriler yoksa
          if (snapshot.hasError && !snapshot.hasData) {
            return const Center(
              child: Text('Hata oluştu. (Yetki veya bağlantı hatası)'),
            );
          }

          // 2. Veri yükleniyorsa
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 3. Veri geldiyse ama içinde belge yoksa
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Henüz mülakat geçmişi yok.'));
          }

          // 4. Veri varsa listele
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              try {
                final session = InterviewSession.fromMap(docs[index].id, data);

                return Card(
                  child: ListTile(
                    title: Text('Mülakat ${index + 1}'),
                    subtitle: Text(
                      session.timestamp.toLocal().toString().split('.')[0],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ResultScreen(
                            qaList: session.answers,
                            save: false,
                          ),
                        ),
                      );
                    },
                  ),
                );
              } catch (e) {
                debugPrint("Firestore parse hatası: $e");
                return const SizedBox(); // Hatalı belgeyi gösterme
              }
            },
          );
        },
      ),
    );
  }
}
