import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memories/models/user.dart';

class UserInformations {
  static final CollectionReference _collection =
      FirebaseFirestore.instance.collection('users');

  static Future<void> insertUserInfo(UserModel user) async {
    await _collection.doc(user.uid).set(user.toJson());
  }

  static Future<UserModel> getUserInfo(String uid) async {
    final _data = await _collection.doc(uid).get();
    return UserModel.fromJson(_data);
  }
}
