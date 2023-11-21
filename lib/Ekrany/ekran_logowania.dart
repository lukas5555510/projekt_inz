import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inzynierka/Ekrany/ekran_glowny.dart';
import 'package:inzynierka/Ekrany/ekran_rejestracji.dart';
import 'package:inzynierka/Ekrany/ekran_weryfikacji_maila.dart';
import 'package:inzynierka/Features/functions.dart';
import 'package:inzynierka/Reusable_widgets/reusable_widget.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

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
        title: const Row(
          children: [
            // Dodaj ikonkę przed tytułem
            Icon(FontAwesomeIcons.rightToBracket, color: Colors.white),
            SizedBox(width: 12), // Odstęp pomiędzy ikonką a tytułem
            Text(
              "Zaloguj się",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.black],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue, // Kolor obramowania
                      width: 6.0, // Szerokość obramowania
                    ),
                    borderRadius:
                    BorderRadius.circular(6.0), // Zaokrąglenie narożników
                  ),
                  child: Image.asset(
                    'lib/images/app_icon.png',
                    height: 250,
                    width: 250,
                  ),
                ),
                const SizedBox(height: 30,),
                reusableTextField(
                  "Wpisz email",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField(
                  "Wpisz hasło",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                singInUpButton(context, true, () async {
                  try {
                    final email = _emailTextController.text;
                    final password = _passwordTextController.text;

                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null && user.emailVerified) {
                      // Użytkownik jest zalogowany i ma zweryfikowany e-mail
                      navigateToScreen(context, MapScreen());
                    } else {
                      // Użytkownik jest zalogowany, ale nie zweryfikował e-maila
                      navigateToScreen(context, VerifyImagePage());
                    }
                  } on FirebaseAuthException catch (e) {
                    print("Error ${e.toString()}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Błąd logowania: ${e.message}'),
                      ),
                    );
                  } catch (e) {
                    print("Inny błąd: $e");
                  }
                }),
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
        const Text("Nie masz konta? ", style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            navigateToScreen(context, SignUpScreen());
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
