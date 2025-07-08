import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _statusMessage;

  Future<void> _sendResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      setState(() => _statusMessage = 'Şifre sıfırlama maili gönderildi.');
    } on FirebaseAuthException catch (e) {
      setState(() => _statusMessage = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Şifremi Unuttum')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendResetEmail,
              child: const Text('Şifre Sıfırlama Bağlantısı Gönder'),
            ),
            const SizedBox(height: 20),
            if (_statusMessage != null)
              Text(
                _statusMessage!,
                style: const TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
