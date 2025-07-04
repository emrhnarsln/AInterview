import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/interview_session.dart';
import 'interview_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<InterviewSession>('sessions');

    return Scaffold(
      appBar: AppBar(title: const Text('Geçmiş Mülakatlar')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<InterviewSession> box, _) {
          if (box.isEmpty) return const Center(child: Text('Kayıt yok'));

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final session = box.getAt(index);
              final dateStr = session!.date.toString().split('.')[0];

              return ListTile(
                title: Text('Mülakat #${index + 1}'),
                subtitle: Text(dateStr),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InterviewDetailScreen(session: session),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
