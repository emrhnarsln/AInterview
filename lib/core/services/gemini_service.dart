import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../features/interview/models/question_answer.dart';

class GeminiService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY']!;

  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-pro', // Daha yaygın desteklenen model
      apiKey: _apiKey,
    );
  }

  Future<String> generateQuestion({
    required String area,
    required String level,
  }) async {
    final prompt =
        '''
You are a technical interviewer.

The user is a $level level $area candidate.

Ask one realistic, non-trivial interview question appropriate for their level.

Make sure the question is **different from typical or previously asked ones**.

Only respond with the question. No explanations, no greetings. Please write the question in Turkish.

''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text?.trim() ?? 'AI herhangi bir soru üretemedi.';
    } catch (e) {
      return 'Soru üretilemedi: $e';
    }
  }

  Future<String> evaluateAnswer({
    required String question,
    required String userAnswer,
  }) async {
    final prompt =
        '''
You are a technical interviewer. Here's the question: "$question"

The user's answer is: "$userAnswer"

Give constructive feedback about the accuracy, clarity, and completeness of the answer. Be helpful and professional.

Only respond with the feedback. No explanations, no greetings. Please write the feedback in Turkish.

''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'AI didn’t return any feedback.';
    } catch (e) {
      return 'AI geri bildirim alınamadı: $e';
    }
  }

  Future<List<String>> evaluateMultipleAnswers(
    List<QuestionAnswer> qaList,
  ) async {
    List<String> idealAnswers = [];

    for (var qa in qaList) {
      final prompt =
          '''
Soru: "${qa.question}"
Kullanıcının cevabı: "${qa.userAnswer}"

Bu soruya verilebilecek kısa ve net bir örnek/ideal cevap yaz.
Sadece cevabı ver, açıklama yazma.
''';

      try {
        final response = await _model.generateContent([Content.text(prompt)]);
        idealAnswers.add(response.text ?? 'AI cevap üretemedi.');
      } catch (e) {
        idealAnswers.add('AI hatası: $e');
      }
    }

    return idealAnswers;
  }

  Future<String> generateContent({required String prompt}) async {
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'AI açıklama üretemedi.';
    } catch (e) {
      return 'Hata oluştu: $e';
    }
  }
}
