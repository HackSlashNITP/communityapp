import 'package:communityapp/models/user_model.dart';
import 'package:communityapp/utils/logging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/custom_widgets.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference databaseReference = FirebaseDatabase.instance.ref('users');
final log = Logging.log;

class AuthService {
  List usernamewithemail = [];

  static Future<bool> signIn(
      String username, String emailAddress, String password) async {
    try {
      // First, get the list of existing users
      List<String> existingUsers = await getUsersList();
      List<String> existingEmails = await getEmailsList();

      // Check if the username or email already exists
      if (existingUsers.contains(username)) {
        log.d('Username already exists.');
        return false; // Abort transaction
      }

      if (existingEmails.contains(emailAddress)) {
        log.d('Email already in use.');
        return false; // Abort transaction
      }

      // Create user with email and password
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      // Create a user object to store in the database
      Map<String, dynamic> userObject = {
        'email': emailAddress,
      };

      // Add the user object to the database under the username
      await databaseReference.child(username).set(userObject);
      await credential.user!.sendEmailVerification();
      log.d('User created successfully: $username');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Error', 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'The account already exists for that email.');
      }
    } catch (e) {
      log.e(e.toString());
    }
    return true;
  }

  static updateInfo(String username, String github, String avatar,
      String linkedin, String name) async {
    final db = FirebaseFirestore.instance.collection("users");
    Map<String, dynamic> userObject = {
      'name': name,
      'avatarlink': avatar,
      'github': github,
      'linkedin': linkedin,
      'joinedGroups': {"-OESi5kZTsOfRXoZHNRV": 0, "-OEToTo5IIB0pk8z4sSn": 0}
    };
    db.doc(username).set(userObject);
    databaseReference.child(username).update(userObject);
  }

  static Future<bool> validateInputs(String username, String email,
      String password, BuildContext context) async {
    List users = await getUsersList();
    List emails = await getEmailsList();

    if (users.contains(username) || username.isEmpty) {
      Get.snackbar('Error', 'Username Not Available or Null');
      return false;
    } else if (emails.contains(email)) {
      Get.snackbar('Error', 'Email Already Used');
      return false;
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email) ||
        email.isEmpty) {
      Get.snackbar('Error', 'Enter a valid email address');
      return false;
    } else if (password.isEmpty || password.length < 6) {
      Get.snackbar('Error', 'Weak Password');
      return false;
    }

    return true;
  }

  static Future<List<String>> getUsersList() async {
    List<String> usersList = [];

    try {
      DatabaseEvent event = await databaseReference.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> usersMap =
            snapshot.value as Map<dynamic, dynamic>;
        usersMap.forEach((key, value) {
          usersList.add(key); // Collect usernames
        });
      } else {
        log.d("No user found");
      }
    } catch (error) {
      log.e('Error retrieving users: $error');
    }

    return usersList;
  }

  static Future<String> getUsername(String email) async {
    try {
      DatabaseEvent event = await databaseReference.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> usersMap =
            snapshot.value as Map<dynamic, dynamic>;

        // Iterate through usersMap
        for (var entry in usersMap.entries) {
          if (entry.value['email'] == email) {
            return entry.key; // Return the key (username) if found
          }
        }
      } else {
        log.d("No user found.");
      }
    } catch (error) {
      log.e("Error retriving users :${error.toString()}");
    }

    // Return "Not found" if the email is not matched
    return "Not found";
  }

  static Future<List<String>> getEmailsList() async {
    List<String> emailsList = [];

    try {
      DatabaseEvent event = await databaseReference.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> usersMap =
            snapshot.value as Map<dynamic, dynamic>;
        usersMap.forEach((key, value) {
          if (value['email'] != null) {
            emailsList.add(value['email']); // Collect emails
          }
        });
      } else {
        log.d("No user found");
      }
    } catch (error) {
      log.e("Error retriving email ${error.toString()}");
    }

    return emailsList;
  }

  static Future<String> getEmailsthroughUsername(String email) async {
    String emailaddress = "user@notFound";
    try {
      DatabaseEvent event = await databaseReference.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> usersMap =
            snapshot.value as Map<dynamic, dynamic>;
        usersMap.forEach((key, value) {
          if (key == email && value['email'] != null) {
            emailaddress = value['email'];
          }
        });
      } else {
        log.d("No user found");
      }
    } catch (error) {
      log.e("Error retriving email ${error.toString()}");
    }

    return emailaddress;
  }

  static Future<types.User> saveUser(String username, String id) async {
    final db = FirebaseFirestore.instance.collection("users").doc(username);
    final doc = await db.get();

    if (doc.exists) {
      Map<String, dynamic> usersMap = doc.data() as Map<String, dynamic>;
      final imageUrl = usersMap['avatarLink'].toString();

      final user = types.User(id: id, imageUrl: imageUrl, firstName: username);
      final box = await Hive.openBox('userBox');
      await box.put("user", HiveUser.fromChatUser(user));
      return user;
    }
    return types.User(id: "NotAvailable", firstName: "NotAvailable");
  }

  static Future<types.User> login(String email, String password) async {
    types.User usr;

    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email)) {
      String emailAddress = await getEmailsthroughUsername(email);
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAddress, password: password);
        final id = credential.user!.uid;
        usr = await AuthService.saveUser(email, id);

        Get.off(() => MainView(
              username: email,
            ));
        return usr;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar('Error', 'No user found for that email.');
          log.e('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Error", "Wrong password provided for that user.");
          log.e('Wrong password provided for that user.');
        }
      }
    } else {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        String username = await getUsername(email);
        if (username == "Not Found") {
          Get.snackbar(
              "Wrong credentials", "User don't exist for given username");
        } else {
          final id = credential.user!.uid;
          usr = await AuthService.saveUser(username, id);
          Get.off(() => MainView(
                username: username,
              ));

          return usr;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar('Error', 'No user found for that email.');
          log.e('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Error", "Wrong password provided for that user.");
          log.e('Wrong password provided for that user.');
        }
      }
    }
    return types.User(id: "NotAvailable");
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
}
