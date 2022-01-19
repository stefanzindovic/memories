import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memories/models/memory.dart';

class MemoryInformations {
  static final CollectionReference _collection =
      FirebaseFirestore.instance.collection('memories');
  static final Reference _storage =
      FirebaseStorage.instance.ref().child('memories_cover_photos');

  static Future<void> createNewMemory(MemoryModel memory) async {
    await _collection.doc(memory.id).set(memory.toJson());
  }
}
