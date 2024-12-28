import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/profile_model.dart';
import '../views/auth/login_view.dart';

class ProfileController extends GetxController {
  var userData = Rxn<ProfileModel>();
  var isLoading = true.obs;
  final String username;

  ProfileController(this.username);

  @override
  void onInit() {
    super.onInit();
    fetchUserData(username);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Fetch UserData
  Future<void> fetchUserData(String username) async {
    try {
      isLoading.value = true;
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(username).get();
      if (snapshot.exists) {
        userData.value = ProfileModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching user data: $e');
      userData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  //Update UserData
  Future<void> updateUserProfile(String name, String linkedin, String github) async {
    try {
      await _firestore.collection('users').doc(username).update({
        'name' : name,
        'linkedin': linkedin,
        'github': github,
      });

      fetchUserData(username);
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  //Delete Account
  Future<void> deleteAccount() async {
    try {
      //Delete user from Firestore
      await _firestore.collection('users').doc(username).delete();
      print('User deleted from Firestore');

      //Delete the user from Firebase Authentication
      User? user = _auth.currentUser;

      if (user != null) {
        await user.delete();
        print('User deleted from Firebase Authentication');
      } else {
        print('No user found in Firebase Authentication');
      }

      Get.offAll(() => LoginView());
    } catch (e) {
      print('Error deleting account: $e');
    }
  }
}

//Controller class fo Edit Profile Page
class EditProfileController extends GetxController {
  final ProfileController profileController;

  EditProfileController(this.profileController);

  var nameController = TextEditingController();
  var linkedinController = TextEditingController();
  var githubController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    if (profileController.userData.value != null) {
      nameController.text = profileController.userData.value!.name;
      linkedinController.text = profileController.userData.value!.linkedin;
      githubController.text = profileController.userData.value!.github;
    }
  }

  // Method to save changes
  Future<void> saveChanges() async {
    String name = nameController.text.trim();
    String linkedin = linkedinController.text.trim();
    String github = githubController.text.trim();

    // Call the update method from ProfileController
    await profileController.updateUserProfile(name, linkedin, github);
    Get.back();
  }
}