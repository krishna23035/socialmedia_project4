import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/pages/login_register.dart';
import '../snooze_button/navigation_bar.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const CustomNavigationBar();
          } else {
            return LoginOrRegisterPage();
          }
        });
  }
}
