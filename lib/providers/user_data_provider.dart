import 'package:flutter/material.dart';
import 'package:memories/models/user.dart';
import 'package:memories/repository/user_informations.dart';

class UserDataProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  Future<void> setUserData(String uid) async {
    _user = await UserInformations.getUserInfo(uid);
    notifyListeners();
  }
}
