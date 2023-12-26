// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String bio;
  final String photoUrl;
  final List<String> followers;
  final List<String> following;
  final List<String> posts;
  final List<String> likedPosts;

  const UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.posts,
    required this.likedPosts,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'email': email,
      'bio': bio,
      'photoUrl': photoUrl,
      'followers': followers,
      'following': following,
      'posts': posts,
      'likedPosts': likedPosts,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    UserModel user = UserModel(
      uid: map['uid'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      bio: map['bio'] as String,
      photoUrl: map['photoUrl'] as String,
      followers: List<String>.from(map['followers'] as List<dynamic>),
      following: List<String>.from(map['following'] as List<dynamic>),
      posts: List<String>.from(map['posts'] as List<dynamic>),
      likedPosts: List<String>.from(map['likedPosts'] as List<dynamic>),
    );
    return user;
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
