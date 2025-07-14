import 'package:flutter/material.dart';
import 'interview_screen.dart';

class InterviewSetupScreen extends StatelessWidget {
  const InterviewSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final areas = ['Yazılım', 'Veri Bilimi', 'Yapay Zeka'];
    final levels = ['Stajyer', 'Junior', 'Mid', 'Senior'];
    String selectedArea = areas[0];
    String selectedLevel = levels[0];

    return Scaffold(
      appBar: AppBar(title: const Text('Mülakat Başlat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                DropdownButtonFormField(
                  value: selectedArea,
                  items: areas
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedArea = val!),
                  decoration: const InputDecoration(labelText: 'Alan'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  value: selectedLevel,
                  items: levels
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedLevel = val!),
                  decoration: const InputDecoration(labelText: 'Seviye'),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Mülakata Başla'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InterviewScreen(
                          area: selectedArea,
                          level: selectedLevel,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
