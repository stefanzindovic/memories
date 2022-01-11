import 'package:firebase_auth/firebase_auth.dart';
import 'package:memories/utils/secure_storage.dart';

class UserAuthentication {
  static final _auth = FirebaseAuth.instance;

  static Future<UserCredential?> signinUser(
      String email, String password) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    await SecureStorage.saveUserCredentialsInStorage(credential);
    return credential;
  }

  static Future<void> signOutUser() async {
    try {
      _auth.signOut();
      SecureStorage.deleteUserCredentialFromStorage();
    } catch (e) {
      print(e);
    }
  }
}
