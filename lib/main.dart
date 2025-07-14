import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/main_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'providers/interview_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(); // .env dosyasını yükle
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
