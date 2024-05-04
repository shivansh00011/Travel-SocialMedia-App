import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String username;
  final String uid;
  final String email;
  final List followers;
  final List following;

  const User({
    required this.username,
    required this.uid,
    required this.email,
    required this.followers,
    required this.following,
  });
   static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson()=>{
    'username': username,
    'uid': uid,
    'email': email,
    'followers': followers,
    'following': following

  };
}