import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:inzynierka/Ekrany/ekran_glowny.dart';
import 'package:inzynierka/Ekrany/ekran_powitalny.dart';

import 'package:inzynierka/Features/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String displayName = "";
  late String email = "";
  String? profilePic;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      setState(() {
        displayName = userData['displayName'];
        email = userData['email'];
      });
    }
  }

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle_outlined, size: 150,),
            const SizedBox(height: 16),
            Text(
              displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
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
                                builder: (context) => const WelcomeScreen(),
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
          ],
        ),
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
        ],
      ),
    );
  }
}
