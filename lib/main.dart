import 'package:flutter/material.dart';
import 'package:socialmedia_project4/AUTH/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialmedia_project4/AUTH/auth.dart';
import 'AUTH/firebase_optiom.dart';
import 'AUTH/phone_login/login_with_phone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Auth(),
    );
  }
}
