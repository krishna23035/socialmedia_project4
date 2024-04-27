import 'package:flutter/material.dart';
import '../pages/homepage.dart';
import '../pages/profile_page.dart';
import '../post/upload_image.dart';
import '../post/video_player.dart'; // Import the video upload page

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
            ),
            child: const Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Upload Image'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewPostsBottom()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('Upload Video'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const
              //       //VideoPlayerWidget(
              //          //   videoFile: null,
              //           )),
            },
          ),
        ],
      ),
    );
  }
}
