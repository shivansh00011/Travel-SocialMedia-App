

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoltrakk/models/user.dart';
import 'package:zoltrakk/resources/firestore_methods.dart';

import 'package:zoltrakk/widgets/comment_card.dart';

import '../providers/userprovider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});
  

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    
    super.dispose();
    _commentController.dispose();
  }
  String username="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
  }
  void getUsername() async{
    DocumentSnapshot snapper = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      username = (snapper.data() as Map<String, dynamic>)['username'];
    });
  }
 
  
     addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
 
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').orderBy('datePublished',descending: true).snapshots(), builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
          
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context , index)=> CommentCard(
            snap: snapshot.data!.docs[index],
          ));
      }),
      bottomNavigationBar: SafeArea(child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,

        ),
        padding: const EdgeInsets.only(left: 16,right: 8),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Comment as $username..',
                    border: InputBorder.none
                  ),
                  
                ),
              ),
            ),
            InkWell(
              onTap: ()async{
                await FirestoreMethods().postComment(widget.snap['postId'], _commentController.text, FirebaseAuth.instance.currentUser!.uid, username);
                setState(() {
                  _commentController.text="";
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Text('Post', style: TextStyle(color: Colors.blue),),
              ),
            )
          ],
        ),
      )),
    );
  }
}