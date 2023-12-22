import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> uploadImageToStorage({
    required Uint8List photo,
    required String path,
    required String uid,
    String? postId,
  }) async {
    Reference ref = _storage.ref().child(path).child(uid);
    if (postId != null) {
      ref = ref.child(postId);
    }
    UploadTask uploadTask = ref.putData(photo);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  static Future<void> deleteImageFromStorage({
    required String path,
    required String uid,
    String? postId,
  }) async {
    Reference ref = _storage.ref().child(path).child(uid);
    if (postId != null) {
      ref = ref.child(postId);
    }
    await ref.delete();
  }
}