import 'package:flutter/cupertino.dart';
import 'package:memories/repository/secure_storage.dart';

class CurrentUserProvider extends ChangeNotifier {
  String? _uid;
  String? _credentials;

  String? get uid => _uid;
  String? get credentials => _credentials;

  Future<void> setUid() async {
    _uid = await SecureStorage.getUserUidFromStorage();
    notifyListeners();
  }

  Future<void> setCredentials() async {
    _credentials = await SecureStorage.getUserCredentialsFromStorage();
    notifyListeners();
  }
}
