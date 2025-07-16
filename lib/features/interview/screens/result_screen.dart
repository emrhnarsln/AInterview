import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/interview_provider.dart';
import '../../../providers/tts_provider.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int? _playingIndex;
  late TtsProvider _tts;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tts = context.read<TtsProvider>();
  }

  @override
  void dispose() {
    _tts.stop(); // context yok, ama daha önce aldığımız referansı kullanıyoruz
    super.dispose();
  }

  Future<void> _handleSpeak(String text, int index) async {
    final tts = context.read<TtsProvider>();

    // Eğer aynı karta tıklandıysa durdur
    if (_playingIndex == index && tts.isPlaying) {
      await tts.stop();
      setState(() => _playingIndex = null);
    } else {
      // Başka kart çalıyorsa durdur, sonra bu kartı başlat
      await tts.stop();
      setState(() => _playingIndex = index);
      await tts.speak(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InterviewProvider>();
    final qaList = provider.qaList;
    final tts = context.watch<TtsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mülakat Sonuçları')),
      body: qaList.isEmpty
          ? const Center(child: Text('Sonuç bulunamadı.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: qaList.length,
              itemBuilder: (context, index) {
                final qa = qaList[index];
                final isThisCardPlaying =
                    _playingIndex == index && tts.isPlaying;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: isThisCardPlaying
                        ? Colors.green[50]
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Yapay Zekadan Geri Bildirim:',
                            style: TextStyle(color: Colors.green[800]),
                          ),
                          IconButton(
                            icon: Icon(
                              isThisCardPlaying ? Icons.stop : Icons.volume_up,
                              color: Colors.green[800],
                            ),
                            tooltip: isThisCardPlaying
                                ? "Geri bildirimi durdur"
                                : "Geri bildirimi sesli dinle",
                            onPressed: () =>
                                _handleSpeak(qa.aiIdealAnswer, index),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(qa.aiIdealAnswer),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
