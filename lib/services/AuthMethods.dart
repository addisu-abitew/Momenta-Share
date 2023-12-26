import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:momenta_share/models/UserModel.dart';
import 'package:momenta_share/services/StorageMethods.dart';

class AuthMethods {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserModel?> getUser() async {
    try {
      final User currentUser = _auth.currentUser!;
      final DocumentSnapshot snapshot = await _firestore.collection('users').doc(currentUser.uid).get();
      return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    } catch (err) {
      return null;
    }
  }

  static Future<String?> signUp({
    required String username,
    required String email,
    required String password,
    required String bio,
    Uint8List? photo,
  }) async {
    try {
      if (username.isEmpty) {
        return 'Please enter a username.';
      } else if (email.isEmpty) {
        return 'Please enter an email address.';
      } else if (password.isEmpty) {
        return 'Please enter a password.';
      } else if (bio.isEmpty) {
        return 'Please enter a bio.';
      } else if (photo == null) {
        return 'Please select a photo.';
      } else {
        final UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        final String photoUrl = await StorageMethods.uploadImageToStorage(photo: photo, path: 'users', uid: credential.user!.uid);
        final UserModel user = UserModel(
          uid: credential.user!.uid,
          username: username,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
          posts: [],
          likedPosts: []
        );
        await _firestore.collection('users').doc(credential.user!.uid).set(user.toMap());
      }
    } on FirebaseAuthException catch(err) {
      if (err.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (err.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if (err.code == 'invalid-email') {
        return 'The email address is not valid.';
      } else {
        return err.toString();
      }
    } catch (err) {
      return err.toString();
    }
    return null;
  }

  static Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    print('Email: $email, Password: $password');
    try {
      if (email.isEmpty) {
        return 'Please enter an email address.';
      } else if (password.isEmpty) {
        return 'Please enter a password.';
      } else {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
      }
    } on FirebaseAuthException catch(err) {
      if (err.code == 'invalid-credential') {
        return 'Either the email or the password is incorrect.';
      } else if (err.code == 'invalid-email') {
        return 'The email address is not valid.';
      } else {
        return err.toString();
      }
    } catch (err) {
      return err.toString();
    }
    return null;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }
}