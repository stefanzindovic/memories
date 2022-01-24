import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> deleteUserCredentialFromStorage() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  static Future<void> saveUserCredentialsInStorage(
      UserCredential credential) async {
    try {
      await _storage.write(key: 'uid', value: credential.user!.uid);
      await _storage.write(
          key: 'email', value: credential.user!.email.toString());
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  static Future<String?> getUserUidFromStorage() async {
    try {
      return await _storage.read(key: 'uid');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  static Future<String?> getUserCredentialsFromStorage() async {
    try {
      return await _storage.read(key: 'email');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
