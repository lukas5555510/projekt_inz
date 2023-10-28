import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inzynierka/Ekrany/ekran_glowny.dart';
import 'package:inzynierka/Ekrany/ekran_rejestracji.dart';
import 'package:inzynierka/Reusable_widgets/reusable_widget.dart';


class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Zaloguj się", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
              reusableTextField("Wpisz login", Icons.person_outline, false, _emailTextController),
              const SizedBox(height: 30,),
              reusableTextField("Wpisz hasło", Icons.lock_outline, true, _passwordTextController),
              const SizedBox(height: 20,),
              singInUpButton(context, true, () {
                FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextController.text,
                    password: _passwordTextController.text).then((value) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MapSample()));
                }).onError((error, stackTrace) {
                  print("Error ${error.toString()}");
                });
              }),
              signUpOption()
            ],
          ),
        ),
      ),
    ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Nie masz konta? ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=> SignUpScreen()));
          },
          child: const Text(
            "Zarejestruj się",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}