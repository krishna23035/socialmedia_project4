import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:socialmedia_project4/profile/profile_page.dart';
import '../appbar.dart';
import '../edit_post/new_post/new_post.dart';
import '../homepage/homepage.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            padding: const EdgeInsets.all(16),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            backgroundColor: Colors.green,
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.blue,
            gap: 12,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.add,
                text: 'New Post',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
                _pageController.jumpToPage(index);
              });
            },
          ),
        ),
      ),
      appBar: CustomAppBar(signOut: signOut),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          HomePage(),
          NewPostsBottom(),
          ProfilePage(),
          //  HiddenPost(postId: widget.postId)
        ],
      ),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
