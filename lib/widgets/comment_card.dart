import 'package:flutter/material.dart';
import 'package:zoltrakk/pages/comment.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final snap;

  const CommentCard({Key? key, required this.snap }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: snap['name'] ,
                          style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 12)
                        ),
                        TextSpan(
                          text: '    ${snap['text']}',
                          style: const TextStyle(color: Colors.black, fontSize: 12)
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(snap['datePublished'].toDate()),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400,),
                    ),
                  )
                ],
              ),
            ),
          ),
         
        ],
      ),
    );
  }
}