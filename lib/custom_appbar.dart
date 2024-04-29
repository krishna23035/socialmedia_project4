import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? signOut;

  const CustomAppBar({super.key, required this.signOut});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white38,
      elevation: 0,
      title:
          //   'assets/images/87390.png',
          //   width: 120,
          //   height: 40,
          //   color: Colors.white,
          // ),
          Image.asset(
        'assets/images/download (1).png',
        width: 780,
        height: 200,
      ),
      actions: [
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
