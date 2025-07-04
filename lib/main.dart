import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/interview_session.dart';

Future<void> main() async {
  await dotenv.load(); // .env dosyasını yükle
  await Hive.initFlutter();
  Hive.registerAdapter(InterviewSessionAdapter());
  Hive.registerAdapter(QuestionAnswerAdapter());
  await Hive.openBox<InterviewSession>('sessions');
  runApp(const MockMeApp());

}

class MockMeApp extends StatelessWidget {
  const MockMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MockMe - AI Mülakat',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomeScreen(),
    );
  }
}
