import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(); // .env dosyasını yükle
  runApp(const AIview());
}

class AIview extends StatelessWidget {
  const AIview({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MockMe - AI Mülakat',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomeScreen(),
    );
  }
}
