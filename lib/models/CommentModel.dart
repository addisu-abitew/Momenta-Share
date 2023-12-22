// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentModel {
  final String id;
  final String comment;
  final String userId;
  final String username;
  final String userPhotoUrl;
  final String postId;
  final DateTime createdAt;
  final List<String> likes;

  CommentModel({
    required this.id,
    required this.comment,
    required this.userId,
    required this.postId,
    required this.createdAt,
    required this.username,
    required this.userPhotoUrl,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'comment': comment,
      'userId': userId,
      'username': username,
      'userPhotoUrl': userPhotoUrl,
      'postId': postId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likes': likes,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as String,
      comment: map['comment'] as String,
      userId: map['userId'] as String,
      username: map['username'] as String,
      userPhotoUrl: map['userPhotoUrl'] as String,
      postId: map['postId'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      likes: List<String>.from(map['likes'] as List<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
