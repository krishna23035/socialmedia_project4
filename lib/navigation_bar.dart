import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:socialmedia_project4/profile/profile_page.dart';

import 'custom_appbar.dart';
import 'homepage/homepage.dart';
import 'homepage/new_post/new_post.dart';

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
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            padding: EdgeInsets.all(16),
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            backgroundColor: Colors.red,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.blue,
            gap: 8,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.add_circle,
                text: 'New Post',
                iconColor: Colors.black,
                iconSize: 35,
              ),
              GButton(
                icon: Icons.person_add_rounded,
                text: 'Profile',
                iconColor: Colors.black,
                iconSize: 30,
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
        children: const [HomePage(), NewPostsBottom(), ProfilePage()],
      ),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
