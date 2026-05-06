import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  if (Firebase.apps.isEmpty) {
    return Stream.value(null);
  }
  return FirebaseAuth.instance.authStateChanges();
});

class AuthController {
  Future<void> login(String email, String password) async {
    if (Firebase.apps.isEmpty) throw Exception("Firebase not configured. Please run flutterfire configure.");
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signup(String name, String email, String password) async {
    if (Firebase.apps.isEmpty) throw Exception("Firebase not configured. Please run flutterfire configure.");
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    await userCredential.user?.updateDisplayName(name);
  }

  Future<void> logout() async {
    if (Firebase.apps.isEmpty) return;
    await FirebaseAuth.instance.signOut();
  }
}

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController();
});
