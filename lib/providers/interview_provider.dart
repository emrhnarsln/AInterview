import 'package:flutter/material.dart';
import '../features/interview/models/question_answer.dart';
import '../core/services/gemini_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InterviewProvider with ChangeNotifier {
  final GeminiService _gemini = GeminiService();

  List<QuestionAnswer> _qaList = [];
  String _currentQuestion = '';
  bool _isLoading = false;
  int _questionIndex = 0;
  final Set<String> _previousQuestions = {};
  late String _area;
  late String _level;

  List<QuestionAnswer> get qaList => _qaList;
  String get currentQuestion => _currentQuestion;
  bool get isLoading => _isLoading;
  int get questionIndex => _questionIndex;

  Future<void> loadNextQuestion(String area, String level) async {
    _isLoading = true;
    notifyListeners();

    if (_qaList.isEmpty) {
      _area = area;
      _level = level;
    }

    String newQuestion = '';
    int attempts = 0;

    do {
      newQuestion = await _gemini.generateQuestion(area: area, level: level);
      attempts++;
    } while (_previousQuestions.contains(newQuestion) && attempts < 2);

    _previousQuestions.add(newQuestion);
    _currentQuestion = newQuestion;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> submitAnswer(String answer) async {
    final question = _currentQuestion;
    final aiIdealAnswer = await _gemini.evaluateAnswer(
      question: question,
      userAnswer: answer,
    );
    final response = {
      'question': question,
      'answer': answer,
      'timestamp': FieldValue.serverTimestamp(),
      'area': _area,
      'level': _level,
      'user_id': FirebaseAuth.instance.currentUser?.uid,
      'user_name': FirebaseAuth.instance.currentUser?.displayName,
      'ai_ideal_answer': aiIdealAnswer,
    };

    _qaList.add(
      QuestionAnswer(
        question: question,
        userAnswer: answer,
        aiIdealAnswer: aiIdealAnswer,
      ),
    );

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('interviews')
          .doc(user.uid)
          .collection('history')
          .add(response);
    }

    notifyListeners();
  }

  void resetInterview() {
    _qaList = [];
    _currentQuestion = '';
    _isLoading = false;
    _questionIndex = 0;
    _previousQuestions.clear();
    notifyListeners();
  }

  void loadFromHistory(List<QuestionAnswer> historyQaList) {
    _qaList = historyQaList;
    notifyListeners();
  }
}
