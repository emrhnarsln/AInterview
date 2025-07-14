import 'package:cloud_firestore/cloud_firestore.dart';

import 'question_answer.dart';

class InterviewSession {
  final String id;
  final String userId;
  final DateTime timestamp;
  final List<QuestionAnswer> answers;

  InterviewSession({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'timestamp': Timestamp.fromDate(timestamp),
      'answers': answers
          .map(
            (a) => {
              'question': a.question,
              'userAnswer': a.userAnswer,
              'aiIdealAnswer': a.aiIdealAnswer,
            },
          )
          .toList(),
    };
  }

  static InterviewSession fromMap(String id, Map<String, dynamic> map) {
    final rawTimestamp = map['timestamp'];
    DateTime parsedTimestamp;

    if (rawTimestamp is Timestamp) {
      parsedTimestamp = rawTimestamp.toDate();
    } else if (rawTimestamp is String) {
      parsedTimestamp = DateTime.parse(rawTimestamp);
    } else {
      throw Exception('Geçersiz timestamp formatı');
    }

    return InterviewSession(
      id: id,
      userId: map['userId'],
      timestamp: parsedTimestamp,
      answers: (map['answers'] as List)
          .map((a) => QuestionAnswer.fromMap(a as Map<String, dynamic>))
          .toList(),
    );
  }
}
