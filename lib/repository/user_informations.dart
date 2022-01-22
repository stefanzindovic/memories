import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memories/models/user.dart';

class UserInformations {
  static final CollectionReference _collection =
      FirebaseFirestore.instance.collection('users');
  static final Reference _storage =
      FirebaseStorage.instance.ref().child('profile_pictures');
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> insertUserInfo(UserModel user) async {
    await _collection.doc(user.uid).set(user.toJson());
  }

  static Future<UserModel?>? getUserInfo(String uid) async {
    final DocumentSnapshot snapshot = await _collection.doc(uid).get();
    if (snapshot.data() == null) {
      return null;
    } else {
      return UserModel.fromJson(snapshot);
    }
  }

  static Future<String> uploadProfilePicture(String uid, File photo) async {
    final TaskSnapshot upload = await _storage.child(uid).putFile(photo);
    return upload.ref.getDownloadURL();
  }

  static Future<void> deleteUserProfilePictureFromStorage(String uid) async {
    await _storage.child(uid).delete();
  }

  static Future<void> updateUserInfo(
      String uid, String name, String? profilePictureUrl) async {
    final UserModel _user =
        UserModel(uid: uid, name: name, profilePhotoUrl: profilePictureUrl);
    await _collection.doc(uid).update(_user.toJson());
  }

  static Future<void> deleteUserAccount() async {
    await _auth.currentUser!.delete();
  }
}
