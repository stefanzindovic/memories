import 'package:flutter/cupertino.dart';
import 'package:memories/utils/secure_storage.dart';

class CurrentUserProvider extends ChangeNotifier {
  String? _uid;
  String? _credentials;

  String? get uid => _uid;
  String? get credentials => _credentials;

  void setUid() async {
    _uid = await SecureStorage.getUserUidFromStorage();
    notifyListeners();
  }

  void setCredentials() async {
    _credentials = await SecureStorage.getUserCredentialsFromStorage();
    notifyListeners();
  }
}
