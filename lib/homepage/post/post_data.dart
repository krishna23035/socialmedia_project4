import 'package:socialmedia_project4/login/widget/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia_project4/homepage/post/post_header.dart';

import '../../edit_post/new_post/firebase_videoplayer.dart';
import '../../helper/helper_method.dart';
import '../../login/widget/comment_button.dart';
import '../../login/widget/like_button.dart';

class FeedPost extends StatefulWidget {
  final String user;
  final String post;
  final String postId;
  final String time;
  final List<String> likes;
  final String? image;
  final String? video;
  final String profileImage;
  final String userId;
  // final VoidCallback onHide; // Added onHide callback

  const FeedPost({
    Key? key,
    required this.user,
    required this.post,
    required this.postId,
    required this.likes,
    required this.time,
    this.image,
    this.video,
    required this.profileImage,
    required this.userId,
    //   required this.onHide, // Define onHide parameter
  }) : super(key: key);

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 8),
            child: PostHead(
              user: widget.user,
              post: widget.post,
              postId: widget.postId,
              time: widget.time,
              profileImage: widget.profileImage,
              userId: widget.userId,
              //     onHide: widget.onHide, // Pass onHide callback to PostHead
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 18.0, right: 18, top: 8),
                    child: Text(
                      widget.post,
                      style: TextStyle(
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ),
                  if (widget.image != null)
                    Image.network(
                      widget.image!,
                    )
                  else if (widget.video != null)
                    FirebaseVideoPlayerWidget(videoUrl: widget.video!),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 8),
            child: Row(
              children: [
                LikeButton(onTap: toggleLikes, isLiked: isLiked),
                const SizedBox(
                  width: 10,
                ),
                CommentButton(onTap: showCommentDialog),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 8),
            child: Text(
              "${widget.likes.length} Likes",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  void toggleLikes() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

  // void hidePost() {
  //   // Trigger the onHide callback
  //   widget.onHide();
  // }

  void showCommentDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 600,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Comment",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 275,
                    child: TextField(
                      controller: _commentTextController,
                      decoration: const InputDecoration(
                        hintText: "Write a comment...",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      addComment(_commentTextController.text);
                      _commentTextController.clear();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.add_circle),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("User Posts")
                      .doc(widget.postId)
                      .collection("Comments")
                      .orderBy("CommentTime", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true, // for nested lists
                      children: snapshot.data!.docs.map((doc) {
                        final commentData = doc.data() as Map<String, dynamic>;
                        return Comment(
                          text: commentData["CommentText"],
                          user: commentData["CommentedBy"],
                          time: formatDate(commentData["CommentTime"]),
                        );
                      }).toList(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
