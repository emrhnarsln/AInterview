import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WhisperService {
  final String _url =
      'http://10.0.2.2:3000/whisper'; // Android emülatör için doğru

  Future<String> transcribeAudio(File audioFile) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_url));
      request.files.add(
        await http.MultipartFile.fromPath('file', audioFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['transcript'] ?? '';
      } else {
        throw Exception('Transcription failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Whisper Error: $e');
    }
  }

  Future<String?> sendAudioToWhisper(String audioFilePath) async {
    final uri = Uri.parse(
      'http://10.0.2.2:3000/whisper',
    ); // Android emülatör için

    try {
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', audioFilePath));

      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final data = jsonDecode(body);
        return data['text'] ??
            data['transcript'] ??
            ''; // Her iki field'ı kontrol et
      } else {
        debugPrint('Whisper API failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Whisper Error: $e');
      return null;
    }
  }
}
