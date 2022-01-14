import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserInformations {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('users');

  Future<void> insertUserInfo() async {
    await _collection.doc('test').set({
      'name': 'Stefan Zindović',
      "profile_picture_url": null,
    });
  }
}