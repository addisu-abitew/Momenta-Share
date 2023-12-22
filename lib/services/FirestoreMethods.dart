import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:momenta_share/models/CommentModel.dart';
import 'package:momenta_share/models/PostModel.dart';
import 'package:momenta_share/models/UserModel.dart';
import 'package:momenta_share/services/StorageMethods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String?> uploadPost({
    required Uint8List image,
    required String uid,
    required String username,
    required String userPhotoUrl,
    required String caption,
  }) async {
    try {
      String postId = const Uuid().v1();
      String imageUrl = await StorageMethods.uploadImageToStorage(photo: image, path: 'posts', uid: uid, postId: postId);
      PostModel post = PostModel(postId: postId, uid: uid, username: username, userPhotoUrl: userPhotoUrl, caption: caption, imageUrl: imageUrl, likes: [], comments: [], createdAt: DateTime.now());
      await _firestore.collection('posts').doc(postId).set(post.toMap());
      await _firestore.collection('users').doc(uid).update({'posts': FieldValue.arrayUnion([postId])});
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> likePost({
    required PostModel post,
    required String uid,
  }) async {
    try {
      if (post.likes.contains(uid)) {
        await _firestore.collection('posts').doc(post.postId).update({'likes': FieldValue.arrayRemove([uid])});
      } else {
        await _firestore.collection('posts').doc(post.postId).update({'likes': FieldValue.arrayUnion([uid])});
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> commentPost({
    required comment,
    required userId,
    required postId,
    required createdAt,
    required username,
    required userPhotoUrl,
    required likes,
  }) async {
    try {
      if (comment.isEmpty) return 'Please enter your comment';
      String id = const Uuid().v1();
      CommentModel commentModel = CommentModel(id: id, comment: comment, userId: userId, postId: postId, createdAt: createdAt, username: username, userPhotoUrl: userPhotoUrl, likes: likes);
      await _firestore.collection('posts').doc(postId).collection('comments').doc(id).set(commentModel.toMap());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  static void likeComment({
    required String commentId,
    required String postId,
    required String userId,
    required List<String> likes,
  }) {
    if (likes.contains(userId)) {
      _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update({'likes': FieldValue.arrayRemove([userId])});
    } else {
      _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update({'likes': FieldValue.arrayUnion([userId])});
    }
  }

  static Future<String?> deletePost({
    required String postId,
    required String uid,
  }) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      await _firestore.collection('users').doc(uid).update({'posts': FieldValue.arrayRemove([postId])});
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> editProfile({
    required UserModel user,
    required String username,
    required String bio,
    Uint8List? photo,
  }) async {
    String updatedUsername = username;
    String updatedBio = bio;
    String updatedPhotoUrl = user.photoUrl;
    if (photo != null) {
      if (user.photoUrl.isNotEmpty) {
        await StorageMethods.deleteImageFromStorage(path: 'users', uid: user.uid);
      }
      String photoUrl = await StorageMethods.uploadImageToStorage(photo: photo, path: 'users', uid: user.uid, postId: '');
      updatedPhotoUrl = photoUrl.isEmpty ? user.photoUrl : photoUrl;
    }
    try {
      await _firestore.collection('users').doc(user.uid).update({'username': updatedUsername, 'bio': updatedBio, 'photoUrl': updatedPhotoUrl});
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}