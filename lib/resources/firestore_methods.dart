import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zoltrakk/models/post.dart';
import 'package:zoltrakk/resources/storage_method.dart';

class FirestoreMethods{
  //  bool scanning=false;
  //  String coordinates="No Location found";
  //  String address='No Address found';
  //  Future<void> getLocation()async{
    
  //   scanning = true;

  //  try{

  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      
  //   coordinates='Latitude : ${position.latitude} \nLongitude : ${position.longitude}';

  //   List<Placemark> result  = await placemarkFromCoordinates(position.latitude, position.longitude);

  //   if (result.isNotEmpty){
  //     address='${result[0].name}, ${result[0].locality} ${result[0].administrativeArea}';
  //   }


  //  }catch(e){
  //   Fluttertoast.showToast(msg:"${e.toString()}");
  //  }
  //  scanning = false;

   
  // }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadPost(
    String description,
    
    String username,
    Uint8List file,
    String uid,
    double latitude,
    double longitude,
  
  ) async{
    String res = "Some error occurred";
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();

      Post post = Post( uid: uid, username: username, likes:[], postId: postId, datePublished: DateTime.now(), postUrl: photoUrl,  description: description, latitude: latitude,longitude: longitude);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res="success";
      
    } catch (err) {
      res =  err.toString();
      
    }
    return res;
    

  }
  Future<String> likePost(String postId, String? uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(String postId, String text, String uid,
      String name) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
    Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
    Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }
}
