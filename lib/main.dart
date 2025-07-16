import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/main_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'providers/interview_provider.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load();

  if (Platform.isAndroid) {
    await Permission.microphone.request();
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => InterviewProvider()),
      ],
      child: const AIview(),
    ),
  );
}

class AIview extends StatelessWidget {
  const AIview({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIview',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return authProvider.isAuthenticated
              ? const MainScreen()
              : const LoginScreen();
        },
      ),
    );
  }
}
