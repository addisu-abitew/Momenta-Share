// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostModel {
  final String postId;
  final String uid;
  final String caption;
  final String imageUrl;
  final List<dynamic> likes;
  final List<String> comments;
  final DateTime createdAt;

  PostModel({
    required this.postId,
    required this.uid,
    required this.caption,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'uid': uid,
      'caption': caption,
      'imageUrl': imageUrl,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] as String,
      uid: map['uid'] as String,
      caption: map['caption'] as String,
      imageUrl: map['imageUrl'] as String,
      likes: List<dynamic>.from(map['likes'] as List<dynamic>),
      comments: List<String>.from(map['comments'] as List<dynamic>),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) => PostModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
