import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zoltrakk/widgets/post_cards.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: SvgPicture.asset('assets/Zoltrakkk.svg', height: 40,),
        
        

      ),
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection('posts').snapshots(), builder: ((context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
        if (snapshot.connectionState==ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),


          );
          
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder:(context, index)=>
           PostCard(
            snap: snapshot.data!.docs[index].data()
           ),
        );

      })),

    );
  }
}