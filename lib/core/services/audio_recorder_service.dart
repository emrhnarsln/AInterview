import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder(); // GÜNCEL SINIF BU
  String? _filePath;

  Future<String> startRecording() async {
    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      throw Exception('🎙️ Mikrofon izni verilmedi');
    }

    final dir = await getApplicationDocumentsDirectory();
    _filePath =
        '${dir.path}/recorded_${DateTime.now().millisecondsSinceEpoch}.webm';

    final config = RecordConfig(
      encoder: AudioEncoder.opus,
      bitRate: 128000,
      sampleRate: 44100,
    );

    await _recorder.start(config, path: _filePath!);

    return _filePath!;
  }

  Future<String?> stopRecording() async {
    await _recorder.stop();
    return _filePath;
  }

  Future<void> cancelRecording() async {
    await _recorder.stop();
    if (_filePath != null) {
      final file = File(_filePath!);
      if (await file.exists()) await file.delete();
    }
  }

  Future<bool> isRecording() async => await _recorder.isRecording();

  void dispose() {}
}
