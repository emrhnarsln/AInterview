import 'package:flutter/material.dart';
import 'interview_screen.dart';
import 'package:provider/provider.dart';
import '../../../providers/tts_provider.dart';

class InterviewSetupScreen extends StatelessWidget {
  const InterviewSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final areas = ['Yazılım', 'Veri Bilimi', 'Yapay Zeka'];
    final levels = ['Stajyer', 'Junior', 'Mid', 'Senior'];
    final ttsProvider = Provider.of<TtsProvider>(context);
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
                DropdownButton<String>(
                  value: ttsProvider.voiceName,
                  onChanged: (value) => ttsProvider.updateVoice(value!),
                  items: [
                    DropdownMenuItem(
                      value: 'en-US-Wavenet-F',
                      child: Text('Kadın - İngilizce'),
                    ),
                    DropdownMenuItem(
                      value: 'en-US-Wavenet-D',
                      child: Text('Erkek - İngilizce'),
                    ),
                    DropdownMenuItem(
                      value: 'tr-TR-Wavenet-A',
                      child: Text('Kadın - Türkçe'),
                    ),
                    DropdownMenuItem(
                      value: 'tr-TR-Wavenet-B',
                      child: Text('Erkek - Türkçe'),
                    ),
                  ],
                ),
                Slider(
                  value: ttsProvider.speed,
                  min: 0.5,
                  max: 2.0,
                  label: "Hız: ${ttsProvider.speed.toStringAsFixed(2)}",
                  onChanged: (val) => ttsProvider.updateSpeed(val),
                ),
                Slider(
                  value: ttsProvider.pitch,
                  min: -5,
                  max: 5,
                  label: "Ton: ${ttsProvider.pitch.toStringAsFixed(2)}",
                  onChanged: (val) => ttsProvider.updatePitch(val),
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
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<TtsProvider>(context, listen: false).speak(
                      "Hello, your answer is correct and well structured.",
                    );
                  },
                  child: Text("TTS ile Geri Bildirim"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
