import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zoltrakk/models/user.dart' as model;
import 'package:zoltrakk/pages/comment.dart';
import 'package:zoltrakk/pages/profile_screen.dart';


import 'package:zoltrakk/providers/userprovider.dart';
import 'package:zoltrakk/resources/auth_method.dart';
import 'package:zoltrakk/resources/firestore_methods.dart';
import 'package:zoltrakk/utils/utils.dart';
import 'package:zoltrakk/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
 
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0 ;
    late User _currentUser;

     @override
  void initState() {
    super.initState();
    fetchCommentLen();
    _currentUser = FirebaseAuth.instance.currentUser!;
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

   deletePost(String postId) async {
    try {
      await FirestoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

 
  bool isLikeAnimating = false;
  addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
   
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
            child: Row(
              children: [
                Expanded(
                  
                  child: Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(uid: widget.snap['uid'])));},
                          child: Text(widget.snap['username'],style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                      ],
                    ),
                  )),
                  IconButton(onPressed: (){
                    showDialog(context: context, builder: (context)=> Dialog(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shrinkWrap: true,
                        children: [
                          'Delete',
                        ].map((e) => InkWell(
                          onTap: (){
                            deletePost(widget.snap['postId'].toString());
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            child: Text(e),
                          ),
                        )).toList()



                      ),
                    ));
                  }, icon: Icon(Icons.more_vert))
              ],
            ),
         

          ),
          GestureDetector(
            onDoubleTap: () async{
              await  FirestoreMethods().likePost(
                widget.snap['postId'],
                _currentUser.uid,
                widget.snap['likes']
              );
              
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      widget.snap['postUrl'].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(_currentUser.uid),
                smallLike: true,
                child: IconButton(onPressed: ()async{
                  await  FirestoreMethods().likePost(
                widget.snap['postId'],
                _currentUser.uid,
                widget.snap['likes']
              );
                }, icon: widget.snap['likes'].contains(_currentUser.uid)? Icon(Icons.favorite, color: Colors.red,):Icon(Icons.favorite_border))),
              IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CommentScreen(snap: widget.snap,)));}, icon: Icon(Icons.comment_outlined,)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.snap['likes'].length} likes', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: widget.snap['username'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
                      ),
                      TextSpan(
                        text: '   ${widget.snap['description']}',
                        style: TextStyle(fontSize: 12)
                        
                      )
                    ]
                  )),
                ),
                InkWell(
                  onTap: (){},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text('View all $commentLen comments', style: TextStyle(fontSize: 15,color: Colors.grey),),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()), style: TextStyle(fontSize: 15,color: Colors.grey),),
                  ),
              ],
            ),
          )
        ],
      ),

    );
    
  }
  
  
}

