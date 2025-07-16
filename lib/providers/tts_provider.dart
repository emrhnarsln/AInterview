import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../core/services/google_tts_service.dart';

class TtsProvider with ChangeNotifier {
  final GoogleTTSService _ttsService = GoogleTTSService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _voiceName = 'tr-TR-Wavenet-A';
  double _speed = 1.0;
  double _pitch = 0.0;

  bool _isPlaying = false;

  // --- Getter'lar (UI erişimi için)
  String get voiceName => _voiceName;
  double get speed => _speed;
  double get pitch => _pitch;
  bool get isPlaying => _isPlaying;

  // --- Ses ayarlarını güncelle
  void updateVoice(String voice) {
    _voiceName = voice;
    notifyListeners();
  }

  void updateSpeed(double newSpeed) {
    _speed = newSpeed;
    notifyListeners();
  }

  void updatePitch(double newPitch) {
    _pitch = newPitch;
    notifyListeners();
  }

  // --- Konuşma başlat
  Future<void> speak(String text) async {
    if (_isPlaying) {
      await stop(); // yeniden bastıysa önce durdur
      return;
    }

    final audioBytes = await _ttsService.synthesizeText(
      text: text,
      voiceName: _voiceName,
      speed: _speed,
      pitch: _pitch,
    );

    if (audioBytes != null) {
      _isPlaying = true;
      notifyListeners();

      await _audioPlayer.play(BytesSource(audioBytes));

      // Ses bitince otomatik durumu sıfırla
      _audioPlayer.onPlayerComplete.listen((event) {
        _isPlaying = false;
        notifyListeners();
      });
    } else {
      debugPrint("🎤 Google TTS'den ses alınamadı.");
    }
  }

  // --- Konuşmayı durdur
  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    notifyListeners();
  }
}
