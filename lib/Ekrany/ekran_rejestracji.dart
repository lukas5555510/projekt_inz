import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inzynierka/Ekrany/ekran_weryfikacji_maila.dart';
import 'package:inzynierka/Reusable_widgets/reusable_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Zarejestruj się",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.blueGrey),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20,),
                reusableTextField("Wpisz imię", Icons.person_outline, false, _userNameTextController),
                const SizedBox(height: 20,),
                reusableTextField("Wpisz e-mail", Icons.email, false, _emailTextController),
                const SizedBox(height: 20,),
                reusableTextField("Wpisz hasło", Icons.lock_outline, true, _passwordTextController),
                const SizedBox(height: 20,),
                singInUpButton(context, false, () async {
                  final email = _emailTextController.text;
                  final password = _passwordTextController.text;
                  final userName = _userNameTextController.text;

                  try {
                    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    // Użytkownik został pomyślnie utworzony
                    final user = userCredential.user;
                    if (user != null) {
                      // Dodaj dane użytkownika do Firestore
                      final userCollection = FirebaseFirestore.instance.collection("users");
                      final userDoc = userCollection.doc(user.uid);

                      // Dodaj dane użytkownika do Firestore
                      userDoc.set({
                        'displayName': userName,
                        'email': email,
                        // Dodaj inne dane użytkownika, jeśli są dostępne
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyImagePage(), // Użyj ekranu weryfikacji e-maila
                        ),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    print("Błąd rejestracji: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Błąd rejestracji: ${e.message}'),
                      ),
                    );
                  } catch (e) {
                    print("Inny błąd: $e");
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
