import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:inzynierka/Ekrany/ekran_glowny.dart';
import 'package:inzynierka/Ekrany/ekran_profilu.dart';
import 'package:page_transition/page_transition.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}
void _navigateToScreen(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.fade, // Możesz dostosować animację według potrzeb
      child: screen,
    ),
  );
}
class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
        backgroundColor: Colors.green,
        color: Colors.white,
        activeColor: Colors.white,
        tabBackgroundColor: Colors.lightGreen,
        gap: 8,
        padding: EdgeInsets.all(20),
        selectedIndex: 2,
        tabs: [
          GButton(
            icon: Icons.map,
            text: "Mapa",
            onPressed: () {
              _navigateToScreen(context, const MapScreen());
            },
          ),
          GButton(
            icon: Icons.person,
            text: "Profil",
            onPressed: () {
              _navigateToScreen(context, const ProfileScreen());
            },
          ),
          GButton(
            icon: Icons.settings,
            text: "Ustawienia",
            onPressed: () {
              _navigateToScreen(context, const SettingsScreen());
            },
          ),
        ],
      ),
    );
  }
}
