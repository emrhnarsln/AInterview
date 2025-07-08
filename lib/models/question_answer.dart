class QuestionAnswer {
  final String question;
  final String userAnswer;
  final String aiIdealAnswer;

  QuestionAnswer({
    required this.question,
    required this.userAnswer,
    required this.aiIdealAnswer,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'userAnswer': userAnswer,
      'aiIdealAnswer': aiIdealAnswer,
    };
  }

  static QuestionAnswer fromMap(Map<String, dynamic> map) {
    return QuestionAnswer(
      question: map['question'] ?? '',
      userAnswer: map['userAnswer'] ?? '',
      aiIdealAnswer: map['aiIdealAnswer'] ?? '',
    );
  }
}
