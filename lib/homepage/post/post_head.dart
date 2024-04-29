import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../edit_post/edit_post_page.dart';

class PostHead extends StatefulWidget {
  final String user;
  final String post;
  final String postId;
  final String time;
  final String profileImage; // Add profileImage parameter

  const PostHead({
    super.key,
    required this.user,
    required this.post,
    required this.postId,
    required this.time,
    required this.profileImage,
  });

  @override
  State<PostHead> createState() => _PostHeadState();
}

class _PostHeadState extends State<PostHead> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.user,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Post Date:',
                      style:
                          TextStyle(color: Colors.grey.shade700, fontSize: 18),
                    ),
                    Text(
                      widget.time,
                      style:
                          TextStyle(color: Colors.grey.shade700, fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                showPopupMenu(context);
              },
              icon: const Icon(
                Icons.more_vert,
                size: 33,
              )),
        ]),
      ],
    );
  }

  void showPopupMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero);

    final RelativeRect positionPopup = RelativeRect.fromRect(
      Rect.fromPoints(
        position.translate(
            button.size.width, 0), // Adjust position to the right of the button
        position.translate(button.size.width, button.size.height),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: positionPopup,
      items: [
        const PopupMenuItem(
          value: 'edit',
          child: Text('Edit'),
        ),
        PopupMenuItem(
          onTap: deletePost,
          value: 'delete',
          child: const Text('Delete'),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 'edit') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditPostPage(postId: widget.postId)));
      } else if (value == 'delete') {
        // Handle delete action
      }
    });
  }

  void deletePost() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text("Delete Post"),
                content:
                    const Text("Are you sure you want to delete this post?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final commentDocs = await FirebaseFirestore.instance
                          .collection("User Posts")
                          .doc(widget.postId)
                          .collection("Comments")
                          .get();

                      for (var doc in commentDocs.docs) {
                        await FirebaseFirestore.instance
                            .collection("User Posts")
                            .doc(widget.postId)
                            .collection("Comments")
                            .doc(doc.id)
                            .delete();
                      }

                      // Delete the post
                      FirebaseFirestore.instance
                          .collection("User Posts")
                          .doc(widget.postId)
                          .delete()
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Post deleted"),
                            duration: Duration(
                                seconds: 2), // Adjust the duration as needed
                          ),
                        );
                      }).catchError((error) {
                        SnackBar(
                          content: Text("Failed to delete post: $error"),
                          duration: const Duration(seconds: 2),
                        );
                      });

                      // Dismiss the dialog
                      Navigator.pop(context);
                    },
                    child: const Text("Delete"),
                  ),
// TextButton
                ]));
  }
}