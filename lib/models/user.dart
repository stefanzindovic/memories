import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String? profilePhotoUrl;

  UserModel({
    required this.uid,
    required this.name,
    this.profilePhotoUrl,
  });
}
