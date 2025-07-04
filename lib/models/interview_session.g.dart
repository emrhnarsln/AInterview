// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interview_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InterviewSessionAdapter extends TypeAdapter<InterviewSession> {
  @override
  final int typeId = 0;

  @override
  InterviewSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InterviewSession(
      date: fields[0] as DateTime,
      qaList: (fields[1] as List).cast<QuestionAnswer>(),
    );
  }

  @override
  void write(BinaryWriter writer, InterviewSession obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.qaList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterviewSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestionAnswerAdapter extends TypeAdapter<QuestionAnswer> {
  @override
  final int typeId = 1;

  @override
  QuestionAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionAnswer(
      question: fields[0] as String,
      userAnswer: fields[1] as String,
      aiIdealAnswer: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionAnswer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.question)
      ..writeByte(1)
      ..write(obj.userAnswer)
      ..writeByte(2)
      ..write(obj.aiIdealAnswer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
