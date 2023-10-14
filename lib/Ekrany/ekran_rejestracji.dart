import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inzynierka/Ekrany/ekran_glowny.dart';
import 'package:inzynierka/Ekrany/ekran_logowania.dart';
import 'package:inzynierka/Reusable_widgets/reusable_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

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
        title: const Text("Zarejestruj się", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.blueGrey),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height *0.2, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20,),
                reusableTextField("Wpisz login", Icons.person_outline, false, _userNameTextController),
                const SizedBox(height: 20,),
                reusableTextField("Wpisz e-mail", Icons.person_outline, false, _emailTextController),
                const SizedBox(height: 20,),
                reusableTextField("Wpisz hasło", Icons.lock_outline, true, _passwordTextController),
                const SizedBox(height: 20,),
                singInUpButton(context, false, () {
                  FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailTextController.text,
                      password: _passwordTextController.text).then((value) {
                        print("Utworzono nowe konto");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LogInScreen()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                  
                  
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
