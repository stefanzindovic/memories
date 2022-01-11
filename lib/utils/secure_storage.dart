import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> deleteUserCredentialFromStorage() {
    throw UnimplementedError();
  }

  static Future<void> saveUserCredentialsInStorage(
      UserCredential credential) async {
    try {
      await _storage.write(key: 'uid', value: credential.user!.uid);
      await _storage.write(key: 'user', value: credential.toString());
    } catch (e) {
      print(e);
    }
  }
}
