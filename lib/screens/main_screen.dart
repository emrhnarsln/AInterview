import 'package:flutter/material.dart';
import 'study_chat_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'interview_setup_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ProfileScreen(),
    StudyChatScreen(),
    Placeholder(), // bu sadece navigasyon için boşluk
    HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const InterviewSetupScreen(), // veya doğrudan InterviewScreen
        ),
      );
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey[800],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'AI ile Çalış',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.record_voice_over),
            label: 'Mülakata Gir',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Geçmiş'),
        ],
      ),
    );
  }
}
