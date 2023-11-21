import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:inzynierka/Ekrany/ekran_glowny.dart';
import 'package:inzynierka/Ekrany/ekran_logowania.dart';
import 'package:inzynierka/Ekrany/ekran_ustawie%C5%84.dart';
import 'package:inzynierka/Features/functions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(), // Pusty kontener, aby rozciągnąć przycisk na środku
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Potwierdź wylogowanie'),
                    content: const Text('Czy na pewno chcesz się wylogować?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Anuluj'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => LogInScreen(),
                            ),
                                (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text('Wyloguj'),
                      )
                    ],
                  );
                },
              );
            },
            child: const Text('Wyloguj się'),
          ),
          Expanded(
            child: Container(), // Pusty kontener, aby rozciągnąć przycisk na środku
          ),
        ],
      ),
      bottomNavigationBar: GNav(
        backgroundColor: Colors.green,
        color: Colors.white,
        activeColor: Colors.white,
        tabBackgroundColor: Colors.lightGreen,
        gap: 8,
        padding: EdgeInsets.all(20),
        selectedIndex: 1,
        tabs: [
          GButton(
            icon: Icons.map,
            text: "Mapa",
            onPressed: () {
              navigateToScreen(context, const MapScreen());
            },
          ),
          GButton(
            icon: Icons.person,
            text: "Profil",
            onPressed: () {
              navigateToScreen(context, const ProfileScreen());
            },
          ),
          GButton(
            icon: Icons.settings,
            text: "Ustawienia",
            onPressed: () {
              navigateToScreen(context, const SettingsScreen());
            },
          ),
        ],
      ),
    );
  }
}

