import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inzynierka/Ekrany/ekran_glowny.dart';
import 'package:inzynierka/Ekrany/ekran_logowania.dart';

class VerifyImagePage extends StatefulWidget {
  const VerifyImagePage({Key? key}) : super(key: key);

  @override
  State<VerifyImagePage> createState() => _VerifyImagePageState();
}

class _VerifyImagePageState extends State<VerifyImagePage> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błąd weryfikacji: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const MapScreen()
      : Scaffold(
          appBar: AppBar(
            title: const Text('Zweryfikuj Email'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Email weryfikacyjny został wysłany na twój adres e-mail',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: const Icon(Icons.email, size: 32),
                  label: const Text(
                    "Wyślij ponownie",
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                ),
                const SizedBox(height: 8),
                TextButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50),),
                  child: const Text("Anuluj", style:TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LogInScreen(), // Przenieś na ekran logowania
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
}
