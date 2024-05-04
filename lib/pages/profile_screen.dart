import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoltrakk/resources/firestore_methods.dart';
import 'package:zoltrakk/utils/utils.dart';
import 'package:zoltrakk/widgets/follow_button.dart';
class ProfileScreen extends StatefulWidget {
  final uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0 ;
  int followers = 0 ;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    
    super.initState();
    getData();
  }
  getData() async{
    setState(() {
      isLoading = true;
    });
    try {
     var userSnap =  await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

     var postSnap = await FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    //  postLen = postSnap.docs.length;
     userData = userSnap.data()!;
     followers = userSnap.data()!['followers'].length;
     following = userSnap.data()!['following'].length;
     isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
     setState(() {
       
     });

      
    } catch (e) {
      showSnackBar(context, e.toString());
      
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isLoading? const Center(child: CircularProgressIndicator(),): Scaffold(
       appBar: AppBar(
        title: Text(userData['username']),
        centerTitle: false,

       ),
       body: ListView(
        children: [
          Padding(padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(userData['username'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),

                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            
                            buildStatColumn(followers, 'followers'),
                            buildStatColumn(following, 'following')
                        
                        
                          ],
                        ),
                          Row(
                    children: [
                    FirebaseAuth.instance.currentUser!.uid == widget.uid?  FollowButton(backgroundColor: Colors.white, borderColor: Colors.grey, text: 'Edit Profile', textColor: Colors.black):
                    isFollowing? FollowButton(backgroundColor: Colors.white, borderColor: Colors.grey, text: 'Unfollow', textColor: Colors.black, function: ()async{
                      await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid'] );
                       setState(() {
                        isFollowing = false;
                        followers--;
                      });
                    },): FollowButton(backgroundColor: Colors.blue, borderColor: Colors.black, text: 'Follow', textColor: Colors.white, function: ()async{
                     
                      await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid'] );

                      setState(() {
                        isFollowing = true;
                        followers++;
                      });
                    
                    })

                    ],
                  )
                      ],
                    ),
                  ),
                
                ],
              ),
            
            ],
          ),
          ),
          const Divider(),
          FutureBuilder(future: FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: widget.uid).get(), builder: (context ,  snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
           
            return Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 5,mainAxisSpacing: 1.5, childAspectRatio: 1), itemBuilder: (context, index){
                  DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                  // postLen = (snapshot.data! as dynamic).docs['postUrl'].length;
                  return Container(
                    child: Image(image: NetworkImage(snap['postUrl']), fit: BoxFit.cover,),
                  );
                }),
            );
          })

          
        ],
       ),
    );
  }
    Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
