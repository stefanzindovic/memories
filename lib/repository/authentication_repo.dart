import 'package:firebase_auth/firebase_auth.dart';
import 'package:memories/models/authenticationModel.dart';

class AuthenticationRepository {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Stream<AuthenticationModel?> get user {
    return _fAuth.authStateChanges().map((User? firebaseUser) =>
        (firebaseUser == null)
            ? AuthenticationModel.fromFirebaseUser(user: firebaseUser)
            : null);
  }
}
