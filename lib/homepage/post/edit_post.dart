import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_method.dart';

class EditPostPage extends StatefulWidget {
  final String postId;

  const EditPostPage({super.key, required this.postId});

  @override
  _EditPostPageState createState() => _EditPostPageState(postId: postId);
}

class _EditPostPageState extends State<EditPostPage> {
  final String postId;
  late TextEditingController _postTextController;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String originalTime = '';
  String editedTime = '';

  _EditPostPageState({required this.postId});

  @override
  void initState() {
    super.initState();
    _postTextController = TextEditingController();
    fetchPostContent();
  }

  @override
  void dispose() {
    _postTextController.dispose();
    super.dispose();
  }

  Future<void> fetchPostContent() async {
    try {
      final DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('User Posts')
          .doc(postId)
          .get();

      if (postSnapshot.exists) {
        setState(() {
          _postTextController.text = postSnapshot['Message'];
          originalTime = formatDate(postSnapshot['TimeStamp']);
          editedTime = postSnapshot['EditedTime'] != null
              ? formatDateTime(postSnapshot['EditedTime'])
              : ''; // If edited time is null, assign an empty string
        });
      }
    } catch (error) {
      print('Error fetching post content: $error');
    }
  }

  String formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}/${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }

  Future<void> updatePost(String newPostText) async {
    try {
      await FirebaseFirestore.instance
          .collection('User Posts')
          .doc(postId)
          .update({'Message': newPostText, 'EditedTime': Timestamp.now()});

      Navigator.pop(
          context); // Go back to the previous screen after updating the post
    } catch (error) {
      print('Error updating post: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              final newPostText = _postTextController.text.trim();
              if (newPostText.isNotEmpty) {
                updatePost(newPostText);
              } else {
                // Show an error message if the post text is empty
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Error'),
                    content: Text('Post text cannot be empty.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.red,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Original Post Time: $originalTime',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Edited Time: $editedTime',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _postTextController,
                maxLines: null,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.edit),
                  hintText: 'Enter your updated post...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 15, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
