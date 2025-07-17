import 'package:flutter/material.dart';
import '../features/study_chat/screens/study_chat_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/interview/screens/interview_setup_screen.dart';
import '../features/interview/screens/history_screen.dart';
import '../features/settings/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  bool _hasOpenedStudyScreen = false;

  final List<Widget> _pages = const [
    ProfileScreen(),
    InterviewSetupScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onFabPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudyChatScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    // Ekran yüklendikten sonra StudyChatScreen'e yönlendirme
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasOpenedStudyScreen) {
        _hasOpenedStudyScreen = true;
        _onFabPressed();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: const Icon(Icons.auto_fix_high),
        backgroundColor: Colors.indigo,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () => _onItemTapped(0),
                color: _selectedIndex == 0 ? Colors.indigo : Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.work_outline),
                onPressed: () => _onItemTapped(1),
                color: _selectedIndex == 1 ? Colors.indigo : Colors.grey,
              ),
              const SizedBox(width: 40), // FAB boşluğu
              IconButton(
                icon: Icon(Icons.history),
                onPressed: () => _onItemTapped(2),
                color: _selectedIndex == 2 ? Colors.indigo : Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => _onItemTapped(3),
                color: _selectedIndex == 3 ? Colors.indigo : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
