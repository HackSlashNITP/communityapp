import 'package:communityapp/utils/logging.dart';
import 'package:communityapp/views/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

final log = Logging.log;

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _StateProfileView();
}

class _StateProfileView extends State<ProfileView> {
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.off(LoginView());
    } catch (e) {
      log.e("Error during logout: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
