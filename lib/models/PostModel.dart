import 'dart:convert';

class PostModel {
  final String postId;
  final String uid;
  final String username;
  final String userPhotoUrl;
  final String caption;
  final String imageUrl;
  final List<dynamic> likes;
  final List<String> comments;
  final DateTime createdAt;

  PostModel({
    required this.postId,
    required this.uid,
    required this.username,
    required this.userPhotoUrl,
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
      'username': username,
      'userPhotoUrl': userPhotoUrl,
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
      username: map['username'] as String,
      userPhotoUrl: map['userPhotoUrl'] as String,
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
