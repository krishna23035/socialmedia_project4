import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia_project4/component/like_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String users;
  final String postId;
  final List<String> likes;

  const WallPost({
    super.key,
    required this.message,
    required this.users,
    required this.postId,
    required this.likes,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  //user from firebase
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    //access the document is firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('user posts').doc(widget.postId);
    if (isLiked) {
      //if the post is now liked , add the user's  email to the likes field

      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      //if the post is now unliked ,remove the user's email from the 'likes' field
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Row(
        children: [
          Column(
            children: [
              LikeButton(
                isLiked: isLiked,
                onTap: toggleLike,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.likes.length.toString(),
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.users,
                style: const TextStyle(color: Colors.blueGrey),
              ),
              const SizedBox(
                height: 10,
                width: 10,
              ),
              //
              Text(widget.message),
            ],
          )
        ],
      ),
    );
  }
}
