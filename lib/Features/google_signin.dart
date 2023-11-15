import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          // Zapisz użytkownika do kolekcji "users" w bazie danych
          FirebaseFirestore.instance.collection("users").doc(user.uid).set({
            'displayName': user.displayName,
            'email': user.email,
            'profilepic': user.photoURL
            // Dodaj inne dane użytkownika, jeśli są dostępne
          });

          return user;
        }
      }
    } catch (e) {
      print("Błąd logowania przez Google: $e");
    }

    return null;
  }
}
