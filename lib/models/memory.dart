import 'package:cloud_firestore/cloud_firestore.dart';

class MemoryModel {
  final String id;
  final String title;
  final String story;
  final String? collectionId;
  final String authorId;
  final String? coverPhotoUrl;
  final int createdAt;
  final bool isFavorite;

  MemoryModel({
    required this.id,
    required this.title,
    required this.story,
    required this.collectionId,
    required this.authorId,
    required this.coverPhotoUrl,
    required this.createdAt,
    required this.isFavorite,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'story': story,
        'collectionId': collectionId,
        'authorId': authorId,
        'coverPhotoUrl': coverPhotoUrl,
        'createdAt': createdAt,
        'isFavorite': isFavorite,
      };

  MemoryModel.fromJson(DocumentSnapshot data)
      : id = data['id'],
        title = data['title'],
        story = data['story'],
        collectionId = data['collectionId'],
        authorId = data['authorId'],
        coverPhotoUrl = data['coverPhotoUrl'],
        createdAt = data['createdAt'],
        isFavorite = data['isFavorite'];
}
