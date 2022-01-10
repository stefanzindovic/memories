import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CurrentUserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;

  Stream<User?> get user => _auth.authStateChanges().map((User? firebaseUser) {
        currentUser = firebaseUser;
        notifyListeners();
      });
}
