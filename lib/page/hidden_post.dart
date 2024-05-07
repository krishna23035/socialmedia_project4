import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HiddenPost extends StatefulWidget {
  const HiddenPost({
    super.key,
  });

  @override
  State<HiddenPost> createState() => _HiddenPostState();
}

class _HiddenPostState extends State<HiddenPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
