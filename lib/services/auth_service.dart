import 'package:communityapp/utils/logging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_widgets.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

final log = Logging.log;

class AuthService {
  List usernamewithemail = [];

  static Future<String> signup(String emailAddress, String password) async {
    try {
      // Create user with email and password
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      await credential.user!.sendEmailVerification();
      final String avatar =
          "https://res.cloudinary.com/daj7vxuyb/image/upload/v1731866387/samples/balloons.jpg";
      updateInfo(
          uid: credential.user!.uid,
          github: "github",
          avatar: avatar,
          linkedin: "linkedin",
          name: "Full Name");
      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Error', 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'The account already exists for that email.');
      } else {
        rethrow;
      }
    } catch (e) {
      log.e(e.toString());
      rethrow;
    }
    throw Exception('Unexpected error occurred during signup');
  }

  static void updateInfo(
      {required String uid,
      required String github,
      required String avatar,
      required String linkedin,
      required String name}) async {
    try {
      final db = FirebaseFirestore.instance.collection("users");
      Map<String, dynamic> userObject = {
        'name': name,
        'avatarlink': avatar,
        'github': github,
        'linkedin': linkedin,
        'joinedGroups': {"-OESi5kZTsOfRXoZHNRV": 0, "-OEToTo5IIB0pk8z4sSn": 0}
      };
      db.doc(uid).set(userObject);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final id = credential.user!.uid;
      Get.off(() => MainView(
            userid: id,
          ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Error", "Wrong password provided for that user.");
      }
      log.e(e.toString());
      rethrow;
    }
  }

  static void forgotPassword() {
    final TextEditingController emailController = TextEditingController();
    Get.defaultDialog(
      title: "Reset Password",
      content: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(hintText: "Enter registered email"),
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          String email = emailController.text;
          if (email.isNotEmpty &&
              RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email)) {
            try {
              await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
              Get.snackbar('Verification Email Sent', 'email: $email');
              Get.back();
            } catch (e) {
              Get.snackbar('Error', 'Please enter a valid email');
            }
            Get.back();
          } else {
            Get.snackbar('Error', 'Please enter a valid email');
          }
        },
        child: Text('Submit'),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back(); // Close the dialog
        },
        child: Text('Cancel'),
      ),
    );
  }

  static String getDisplayName() {
    final user = FirebaseAuth.instance;
    return user.currentUser!.displayName.toString();
  }
}
