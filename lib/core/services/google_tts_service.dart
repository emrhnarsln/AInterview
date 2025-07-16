import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleTTSService {
  final String _apiKey = dotenv.env['GOOGLE_TTS_API_KEY']!;

  Future<Uint8List?> synthesizeText({
    required String text,
    String voiceName = 'en-US-Wavenet-F',
    double speed = 1.0,
    double pitch = 0.0,
  }) async {
    final url = Uri.parse(
      'https://texttospeech.googleapis.com/v1/text:synthesize?key=$_apiKey',
    );

    final requestBody = {
      "input": {"text": text},
      "voice": {"languageCode": "tr-TR", "name": voiceName},
      "audioConfig": {
        "audioEncoding": "MP3",
        "speakingRate": speed,
        "pitch": pitch,
      },
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final audioContent = responseData['audioContent'];
      return base64Decode(audioContent);
    } else {
      print("TTS Error: ${response.body}");
      return null;
    }
  }
}
