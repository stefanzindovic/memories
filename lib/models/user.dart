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

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'profilePhotoUrl': profilePhotoUrl,
      };

  UserModel.fromJson(DocumentSnapshot data)
      : uid = data['uid'],
        name = data['name'],
        profilePhotoUrl = data['profilePhotoUrl'];
}
