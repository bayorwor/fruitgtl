import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/services/file_upload.dart';

class PostController with ChangeNotifier {
  static final FirebaseFirestore _firebaseFireStore =
      FirebaseFirestore.instance;
  final CollectionReference<Map<String, dynamic>> _postCollection =
      _firebaseFireStore.collection("fruits");

  final FileUploadService _fileUploadService = FileUploadService();

  String _message = "";

  String get message => _message;

  setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  Future<bool> createPost({String? name, required File postImage}) async {
    bool isSubmitted = false;

    String? photoUrl = await _fileUploadService.uploadPostFile(file: postImage);

    if (photoUrl != null) {
      await _postCollection.doc().set({
        "name": name,
        "image": photoUrl,
      }).then((_) {
        isSubmitted = true;
        setMessage("Post successfully submitted");
      }).catchError((error) {
        isSubmitted = false;
        setMessage("$error");
      }).timeout(const Duration(seconds: 60), onTimeout: () {
        isSubmitted = false;
        setMessage("weak or no network");
      });
    } else {
      isSubmitted = false;
      setMessage("not image found");
    }
    return isSubmitted;
  }

  Stream<QuerySnapshot<Map<String, dynamic>?>> getAllPosts() {
    return _postCollection.snapshots();
  }
}
