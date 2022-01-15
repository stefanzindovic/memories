import 'package:memories/models/user.dart';
import 'package:memories/repository/user_informations.dart';

class UserInfoProvider {
  UserModel? _userData;

  UserModel? get userData => _userData;

  Future<void> setUserData(String uid) async {
    _userData = await UserInformations.getUserInfo(uid);
  }
}
