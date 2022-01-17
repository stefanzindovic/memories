import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CollectionsInformations {
  static final CollectionReference _collection =
      FirebaseFirestore.instance.collection('collections');
  static final Reference _storage =
      FirebaseStorage.instance.ref().child('collection_cover_pictures');
}
