import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/auth/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<AuthProvider>().user;
    if (user != null && isLoading) {
      _loadUserData(user);
    }
  }

  Future<void> _loadUserData(firebase_auth.User user) async {
    final authProvider = context.read<AuthProvider>();

    try {
      final data = await authProvider.fetchUserData();
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        userData = null;
        isLoading = false;
      });
    }
  }

  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate().toLocal().toString().split('.')[0];
    }
    return '-';
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Giriş yapılmamış.')));
    }

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text('Profil bilgileri yüklenemedi.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
          ? const Center(child: Text('Profil bilgileri yüklenemedi.'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${userData!['email']}'),
                  const SizedBox(height: 12),
                  Text(
                    'Kayıt Tarihi: ${formatTimestamp(userData!['createdAt'])}',
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      await context.read<AuthProvider>().signOut();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text('Çıkış Yap'),
                  ),
                ],
              ),
            ),
    );
  }
}
