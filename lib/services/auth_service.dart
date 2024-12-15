import 'package:communityapp/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference databaseReference = FirebaseDatabase.instance.ref('users');

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
        print('Username already exists.');
        return false; // Abort transaction
      }

      if (existingEmails.contains(emailAddress)) {
        print('Email already in use.');
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
      print('User  created successfully: $username');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return true;
  }

  static updateInfo(String username, String github, String avatar,
      String linkedin, String name) async {
    Map<String, dynamic> userObject = {
      'name': name,
      'avatarlink': avatar,
      'github': github,
      'linkedin': linkedin,
    };
    databaseReference.child(username).update(userObject);
  }
   
  static Future<bool> validateInputs(String username, String email,
      String password, BuildContext context) async {
    List users = await getUsersList();
    List emails = await getEmailsList();

    if (users.contains(username) || username.isEmpty) {
      SnackBar snackBar =
          const SnackBar(content: Text("Username Not Available or Null"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    } else if (emails.contains(email)) {
      SnackBar snackBar = const SnackBar(content: Text("Email Already Used"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email) ||
        email.isEmpty) {
      SnackBar snackBar =
          const SnackBar(content: Text("enter a valid email address"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    } else if (password.isEmpty || password.length < 6) {
      SnackBar snackBar = const SnackBar(content: Text("Weak Password"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        print('No users found.');
      }
    } catch (error) {
      print('Error retrieving users: $error');
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
        print('No users found.');
      }
    } catch (error) {
      print('Error retrieving users: $error');
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
        print('No users found.');
      }
    } catch (error) {
      print('Error retrieving emails: $error');
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
        print(usersMap);
        usersMap.forEach((key, value) {
          print(key);
          if (key == email && value['email'] != null) {
            emailaddress = value['email'];
          }
        });
      } else {
        print('No users found.');
      }
    } catch (error) {
      print('Error retrieving emails: $error');
    }

    return emailaddress;
  }

  static Future<UserModel> saveUser(String username) async {
    final event = await databaseReference.child(username).once();
    final snapshot = event.snapshot;
    if (snapshot.exists) {
      Map<dynamic, dynamic> usersMap = snapshot.value as Map<dynamic, dynamic>;
      UserModel usr = UserModel.fromJson(usersMap, username);
      return usr;
    }
    return UserModel();
  }

  static Future<UserModel> Login(String email, String password) async {
    UserModel usr;
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email)) {
      print("I am in username finder code");
      String emailAddress = await getEmailsthroughUsername(email);
      print(emailAddress);
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAddress, password: password);
        usr = await AuthService.saveUser(email);
        return usr;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    } else {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        String username = await getUsername(email);
        usr = await AuthService.saveUser(email);
        return usr;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
    return UserModel();
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
