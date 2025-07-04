import 'package:flutter/material.dart';
import 'interview_screen.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  String selectedArea = 'Yazılım';
  String selectedLevel = 'Stajyer';

  final areas = ['Yazılım', 'Veri Bilimi', 'Yapay Zeka'];
  final levels = ['Stajyer', 'Junior', 'Mid', 'Senior'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alan ve Seviye Seç')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedArea,
              items: areas
                  .map(
                    (area) => DropdownMenuItem(value: area, child: Text(area)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => selectedArea = value!),
              decoration: const InputDecoration(labelText: 'Alan'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedLevel,
              items: levels
                  .map(
                    (level) =>
                        DropdownMenuItem(value: level, child: Text(level)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => selectedLevel = value!),
              decoration: const InputDecoration(labelText: 'Seviye'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
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
              child: const Text('Başla'),
            ),
          ],
        ),
      ),
    );
  }
}
