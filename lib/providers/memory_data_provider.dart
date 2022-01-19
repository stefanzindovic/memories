import 'package:flutter/material.dart';
import 'package:memories/models/memory.dart';
import 'package:memories/repository/memory_informations.dart';

class MemoryDataProvider extends ChangeNotifier {
  List<MemoryModel?> _memories = [];

  List<MemoryModel?> get memories => _memories;

  Future<void> setMemories(String uid) async {
    _memories = await MemoryInformations.getMemories(uid);
    notifyListeners();
  }
}
