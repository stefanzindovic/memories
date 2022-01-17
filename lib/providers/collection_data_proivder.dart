import 'package:flutter/material.dart';
import 'package:memories/models/collection.dart';
import 'package:memories/repository/collections.dart';

class CollectionDataProvoder extends ChangeNotifier {
  List<CollectionModel?> _collections = [];

  List<CollectionModel?> get collections => _collections;

  Future<void> setCollections(String uid) async {
    _collections = await CollectionsInformations.getUserCollections(uid);
    notifyListeners();
  }
}
