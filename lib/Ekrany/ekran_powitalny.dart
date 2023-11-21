import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inzynierka/Ekrany/ekran_glowny.dart';
import 'package:inzynierka/Ekrany/ekran_logowania.dart';
import 'package:inzynierka/Ekrany/ekran_rejestracji.dart';
import 'package:inzynierka/Features/functions.dart';
import 'package:inzynierka/Features/google_signin.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              20,
              MediaQuery.of(context).size.height * 0.1,
              20,
              0,
            ),
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
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Witaj w aplikacji dodawania wydarzeń i incydentów na mapę!",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center, // Wyśrodkuj tekst
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Zaloguj się do swojego konta, aby kontynuować",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  icon:
                      const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                  label: const Text("Zaloguj się przez Google"),
                  onPressed: () async {
                    final authService = AuthService();
                    try {
                      final user = await authService.signInWithGoogle();
                      if (user != null) {
                        // Logowanie się powiodło, przekieruj na ekran MapSample
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const MapScreen(),
                          ),
                        );
                      } else {
                        // Użytkownik anulował logowanie, nie rób nic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Anulowano logowanie przez Google'),
                          ),
                        );
                      }
                    } catch (e) {
                      if (e.toString() ==
                          'PlatformException(sign_in_canceled, com.google.android.gms.common.api.ApiException: 12500: , null, null)') {
                        // Użytkownik anulował logowanie, nie rób nic
                      } else {
                        // Wyświetl komunikat o błędzie
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Błąd logowania przez Google: $e'),
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                    text: "Masz już konto? ",
                    children: [
                      TextSpan(
                        text: "Zaloguj się",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors
                              .white,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Obsłuż kliknięcie i przekieruj na ekran LogInScreen
                            navigateToScreen(context, const LogInScreen());
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    text: "Nie masz konta? ",
                    children: [
                      TextSpan(
                        text: "Zarejestruj się",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors
                              .white,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Obsłuż kliknięcie i przekieruj na ekran LogInScreen
                            navigateToScreen(context, const SignUpScreen());
                          },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
