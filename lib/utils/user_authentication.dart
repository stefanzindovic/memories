import 'package:firebase_auth/firebase_auth.dart';
import 'package:memories/utils/secure_storage.dart';

class UserAuthentication {
  static final _auth = FirebaseAuth.instance;

  static Future<void> signOutUser() async {
    try {
      _auth.signOut();
      SecureStorage.deleteUserCredentialFromStorage();
    } catch (e) {
      print(e);
    }
  }
}
