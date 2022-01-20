import 'package:flutter/material.dart';
import 'package:memories/models/memory.dart';
import 'package:memories/repository/memory_informations.dart';

class MemoryDataProvider extends ChangeNotifier {
  List<MemoryModel?> _memories = [];
  List<MemoryModel?> _favoriteMemories = [];
  List<MemoryModel?> _collectionMemories = [];

  List<MemoryModel?> get memories => _memories;
  List<MemoryModel?> get favoriteMemories => _favoriteMemories;
  List<MemoryModel?> get collectionMemories => _collectionMemories;

  Future<void> setMemories(String uid) async {
    _memories = await MemoryInformations.getMemories(uid);
    notifyListeners();
  }

  Future<void> setFavoriteMemories(String uid) async {
    _favoriteMemories =
        await MemoryInformations.getMemoriesByFavoriteStatus(uid);
    notifyListeners();
  }

  Future<void> setMemoriesByCollection(String uid, String id) async {
    _collectionMemories =
        await MemoryInformations.getMemoriesByCollection(uid, id);
    notifyListeners();
  }
}
