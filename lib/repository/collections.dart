import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memories/models/collection.dart';

class CollectionsInformations {
  static final CollectionReference _collection =
      FirebaseFirestore.instance.collection('collections');
  static final Reference _storage =
      FirebaseStorage.instance.ref().child('collection_cover_pictures');

  static Future<void> createNewCollection(CollectionModel collection) async {
    await _collection.doc(collection.id).set(collection.toJson());
  }

  static Future<String> uploadCoverPhoto(
      String collectionId, File photo) async {
    final TaskSnapshot upload =
        await _storage.child(collectionId).putFile(photo);
    return upload.ref.getDownloadURL();
  }
}
