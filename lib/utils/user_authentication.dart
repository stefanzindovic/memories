import 'package:firebase_auth/firebase_auth.dart';
import 'package:memories/utils/secure_storage.dart';

class UserAuthentication {
  static final _auth = FirebaseAuth.instance;

  static Future<void> signinUser(String email, String password) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    await SecureStorage.saveUserCredentialsInStorage(credential);
  }

  static Future<void> signupUser(String email, String password) async {
    final UserCredential credential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);
    await SecureStorage.saveUserCredentialsInStorage(credential);
  }

  static Future<void> signoutUser() async {
    _auth.signOut();
    SecureStorage.deleteUserCredentialFromStorage();
  }
}
