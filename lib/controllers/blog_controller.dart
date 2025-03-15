import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:communityapp/models/blog_model.dart';
import 'package:communityapp/views/learning/blogs/blogpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';

class BlogController extends GetxController {
  final Logger log = Logger(); // Logger instance

  RxBool isLoading = false.obs;

  final titleController = TextEditingController().obs;
  final contentController = TextEditingController().obs;

  var localImage = Rx<File?>(null); // For mobile
  var webImageBytes = Rx<Uint8List?>(null); // For web
  var imageUrl = RxString(""); // Stores uploaded image URL
  var isUploadingImage = false.obs; // Uploading status

  final CloudinaryPublic cloudinary =
      CloudinaryPublic('daj7vxuyb', 'nehi1ybz', cache: false);

  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (kIsWeb) {
        webImageBytes.value = await image.readAsBytes();
      } else {
        localImage.value = File(image.path);
      }
      update(); // Notify UI
      await uploadImage();
    } else {
      log.w("❌ No image selected");
    }
  }

  Future<void> uploadImage() async {
    isUploadingImage.value = true;
    update();

    try {
      log.i("📤 Uploading image...");

      CloudinaryResponse response;

      if (kIsWeb && webImageBytes.value != null) {
        response = await cloudinary.uploadFile(
          CloudinaryFile.fromByteData(
              ByteData.view(webImageBytes.value!.buffer),
              resourceType: CloudinaryResourceType.Image,
              identifier:
                  'web_upload_${DateTime.now().millisecondsSinceEpoch}'),
        );
      } else if (!kIsWeb && localImage.value != null) {
        response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(localImage.value!.path,
              resourceType: CloudinaryResourceType.Image),
        );
      } else {
        log.e("❌ No image found for upload.");
        Get.snackbar("Upload Error", "No image selected.");
        return;
      }

      imageUrl.value = response.secureUrl;
      log.i("✅ Image Uploaded Successfully: ${imageUrl.value}");
    } catch (e) {
      log.e("🚨 Cloudinary Upload Error: $e");
      Get.snackbar("Upload Error", "Something went wrong while uploading.");
    } finally {
      isUploadingImage.value = false;
      update();
    }
  }

  //  SUBMIT POST TO FIREBASE
  Future<void> submitPost() async {
    log.i("🚀 Submitting Post...");

    String title = titleController.value.text.trim();
    String content = contentController.value.text.trim();
    String uploadedImageUrl = imageUrl.value;

    // 🔍 Check if all fields are filled
    if (title.isEmpty) {
      Get.snackbar("Error", "Title is required.");
      log.w("❌ Submission Failed: Some fields are empty.");
      return;
    }
    if (content.isEmpty) {
      Get.snackbar("Error", " Content is required.");
      log.w("❌ Submission Failed: Some fields are empty.");
      return;
    }
    if (uploadedImageUrl.isEmpty) {
      Get.snackbar("Error", "Image is required.");
      log.w("❌ Submission Failed: Some fields are empty.");
      return;
    }

    //  Check if image is still uploading
    if (isUploadingImage.value) {
      Get.snackbar("Uploading", "Please wait for image to finish uploading.");
      log.w("⏳ Waiting for image upload to complete...");
      return;
    }

    isUploadingImage.value = !isUploadingImage.value;

    try {
      log.i("📡 Uploading Data to Firebase...");

      BlogModel blogModel = BlogModel(
          title: title,
          content: content,
          author: FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous",
          imageUrl: uploadedImageUrl,
          createdAt: DateTime.now().toIso8601String());

      final blogRef = FirebaseFirestore.instance
          .collection('blogPosts')
          .withConverter<BlogModel>(
            fromFirestore: (snapshot, _) =>
                BlogModel.fromJson(snapshot.data() as Map<String, dynamic>),
            toFirestore: (blog, _) => blog.toJson(),
          );
      await blogRef.doc().set(blogModel);

      log.i("✅ Post Uploaded Successfully!");

      // Reset fields after submission
      titleController.value.clear();
      contentController.value.clear();
      imageUrl.value = '';
      localImage.value = null;
      webImageBytes.value = null;

      // 🔄 Navigate back after submission
      Get.snackbar("Success", "Post uploaded successfully!");
      Get.offAll(() => Blog_Page());
    } catch (e) {
      log.e("🚨 Firebase Upload Error: $e");
      Get.snackbar("Error", "Failed to upload post.");
    }

    isUploadingImage.value = !isUploadingImage.value;
  }

  Stream<List<BlogModel>> getAllBlogPostsStream() {
    final blogRef = FirebaseFirestore.instance
        .collection('blogPosts')
        .orderBy('createdAt', descending: true)
        .withConverter<BlogModel>(
          fromFirestore: (snapshot, _) =>
              BlogModel.fromJson(snapshot.data() as Map<String, dynamic>),
          toFirestore: (blog, _) => blog.toJson(),
        );

    return blogRef.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((doc) => doc.data()).toList());
  }
}
