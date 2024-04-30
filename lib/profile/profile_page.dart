import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmedia_project4/profile/textbos.dart';

import '../Homepage/Post/feed_post.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollections = FirebaseFirestore.instance.collection("Users");
  File? _imageFile;
  bool _isLoading = false;
  bool isPrivate = false;
  int followersCount = 0;
  int followingCount = 0;

  Future<void> fetchFollowerFollowingCounts() async {
    //query follower's count
    final followersQuery = await userCollections
        .doc(currentUser.email)
        .collection('Followers')
        .get();
    setState(() {
      followersCount = followersQuery.docs.length;
    });
//query following count
    final followingQuery = await userCollections
        .doc(currentUser.email)
        .collection('Following')
        .get();
    setState(() {
      followingCount = followingQuery.docs.length;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFollowerFollowingCounts(); // Call fetchFollowerFollowingCounts() here
  }

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(newValue);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newValue.isNotEmpty) {
      await userCollections.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height *
              0.5, // Adjust height as needed
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final profilePicturePath = userData['profile_img'] as String?;
                return ListView(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: _imageFile != null
                          ? CircleAvatar(
                              radius: 36,
                              backgroundImage:
                                  FileImage(File(profilePicturePath!)),
                            )
                          : IconButton(
                              icon: Icon(Icons.person, size: 72),
                              onPressed: () {
                                _pickImage();
                              },
                            ),
                    ),
                    Text(
                      currentUser.email.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        'My Profile',
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 17),
                      ),
                    ),
                    MyTextBox(
                      text: userData['username'],
                      sectionName: 'username',
                      onPressed: () {
                        editField('username');
                      },
                    ),
                    MyTextBox(
                      text: userData['bio'],
                      sectionName: 'bio',
                      onPressed: () {
                        editField('bio');
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextBox(
                      text: userData['contact'].toString(),
                      sectionName: 'contact',
                      onPressed: () {
                        editField('contact');
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //display follower and following count
                    Text(
                      'Followers:$followersCount',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text('Following:$followingCount'),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 25.0),
        ),

        //  isPrivate ? _buildPrivatePosts() : _buildPublicPosts(),
      ])),
    );
  }

  Widget _buildPrivatePosts() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Posts")
          .where('owner', isEqualTo: currentUser.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Display posts
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  // Function to build public posts
  Widget _buildPublicPosts() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Posts").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Display posts
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedImage = await _cropImage(File(pickedFile.path));
      setState(() {
        _imageFile = croppedImage;
      });

      // Upload the cropped image to Firebase Storage
      final imageUrl = await _uploadImageToFirebaseStorage(croppedImage);

      // Update the profile picture URL in Firestore
      await userCollections
          .doc(currentUser.email)
          .update({'profile_img': imageUrl ?? 'no image'});
    }
  }

  Future<File> _cropImage(File imageFile) async {
    // Implement image cropping logic here (You can use packages like 'image_cropper')
    // For demonstration purposes, let's assume image cropping is already done
    return imageFile;
  }

  Future<String> _uploadImageToFirebaseStorage(File imageFile) async {
    try {
      String fileName = '${currentUser.email!}_profile_pic.jpg';
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_pictures/$fileName');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return '';
    }
  }

  Future<Map<String, dynamic>> getUserData(String email) async {
    final userCollection = FirebaseFirestore.instance.collection("Users");
    final userDoc = await userCollection.doc(email).get();
    final userData = userDoc.data();
    return userData ?? {};
  }

  Future<void> _refreshHomePage() async {
    setState(() {
      _isLoading = true;
    });

    // Add some delay for demonstration purposes
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }
}
