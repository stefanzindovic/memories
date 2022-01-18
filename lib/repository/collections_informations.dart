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

  static Future<List<CollectionModel?>> getUserCollections(String uid) async {
    List<CollectionModel?> collections = [];
    final QuerySnapshot snapshots =
        await _collection.where('authorId', isEqualTo: uid).get();

    List docs = snapshots.docs;
    for (var doc in docs) {
      if (doc != null) {
        collections.add(CollectionModel.fromJson(doc));
      }
    }
    return collections;
  }

  static Future<void> deleteCollection(String collectionId) async {
    final collection = await _collection.doc(collectionId).get();
    final data = collection.data() as Map;

    if (data['coverPhotoUrl'] != null) {
      await _storage.child(collectionId).delete();
    }
    await _collection.doc(collectionId).delete();
  }
}
