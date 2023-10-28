import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inzynierka/Ekrany/ekran_glowny.dart';
import 'package:inzynierka/Ekrany/ekran_logowania.dart';
import 'package:inzynierka/Features/google_signin.dart';



class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(color: Colors.blueGrey),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height *0.2, 20, 0),
          child:  Column(
            children: <Widget>[
              const Text("Witaj w aplikacji dodawania wydarzeń bądź incydentów na mapę!", style: TextStyle(fontSize: 25, color: Colors.white),),
              const SizedBox(height: 30,),
              const Text("Zaloguj się do swojego konta, aby kontynuować", style: TextStyle(fontSize: 25)),
              const SizedBox(height: 30,),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                label: const Text("Zaloguj się przez Google"),
                onPressed: () async {
                  final authService = AuthService();
                  final result = await authService.signInWithGoogle();

                  if (result == null) {
                    // Użytkownik anulował logowanie
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Logowanie przez Google anulowane.'),
                      ),
                    );
                  } else if (result is User) {
                    // Logowanie się powiodło
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MapSample(),
                      ),
                    );
                  } else {
                    // Wyświetl komunikat o błędzie
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Błąd logowania przez Google: $result'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 30,),
              signUpOption(),
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
        const Text("Masz już konto? ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=> const LogInScreen()));
          },
          child: const Text(
            "Zaloguj się",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
