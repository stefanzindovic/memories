import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionModel {
  final String id;
  final String title;
  final String? coverPhotoUrl;
  final String authorId;

  CollectionModel({
    required this.id,
    required this.title,
    required this.coverPhotoUrl,
    required this.authorId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'coverPhotoUrl': coverPhotoUrl,
        'authorId': authorId,
      };

  CollectionModel.fromJson(DocumentSnapshot data)
      : id = data['id'],
        title = data['title'],
        coverPhotoUrl = data['coverPhotoUrl'],
        authorId = data['authorId'];
}
