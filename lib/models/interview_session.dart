import 'package:hive/hive.dart';

part 'interview_session.g.dart';

@HiveType(typeId: 0)
class InterviewSession extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final List<QuestionAnswer> qaList;

  InterviewSession({
    required this.date,
    required this.qaList,
  });
}

@HiveType(typeId: 1)
class QuestionAnswer {
  @HiveField(0)
  final String question;

  @HiveField(1)
  final String userAnswer;

  @HiveField(2)
  final String aiIdealAnswer;

  QuestionAnswer({
    required this.question,
    required this.userAnswer,
    required this.aiIdealAnswer,
  });
}
