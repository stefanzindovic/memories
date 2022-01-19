import 'dart:io';

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

  static Future<String> uploadMemoryCoverPhoto(String id, File photo) async {
    final TaskSnapshot upload = await _storage.child(id).putFile(photo);
    return upload.ref.getDownloadURL();
  }

  static Future<void> deleteMemoryCoverPhoto(String id) async {
    await _storage.child(id).delete();
  }

  static Future<List<MemoryModel?>> getMemories(String uid) async {
    List<MemoryModel?> memories = [];

    final QuerySnapshot snapshots =
        await _collection.where('authorId', isEqualTo: uid).get();
    final List docs = snapshots.docs;

    for (var doc in docs) {
      if (doc != null) {
        memories.add(MemoryModel.fromJson(doc));
      }
    }

    return memories;
  }
}
