import 'package:flutter/material.dart';
import 'package:socialmedia_project4/page/hidden_post.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? signOut;

  const CustomAppBar({
    super.key,
    required this.signOut,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white38,
      elevation: 0,
      title: Image.asset(
        'assets/images/download (1).png',
        width: 780,
        height: 200,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.hide_image_sharp),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HiddenPost()));
          },
        ),
        IconButton(
          onPressed: signOut,
          icon: const Icon(Icons.logout_sharp),
          color: Colors.blue,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
