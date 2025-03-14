import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';  
import 'package:communityapp/views/learning/blogs/blogpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class BlogController extends GetxController {
  final Logger log = Logger(); // Logger instance

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  
  RxBool _isUploadingImage = false.obs;
  bool get isUploadingImage => _isUploadingImage.value;

  final titleController = TextEditingController().obs;
  final contentController = TextEditingController().obs;
  Rx<File?> localImage = Rx<File?>(null);
  RxString imageUrl = ''.obs;

  void changeLoad() {
    _isLoading.value = !_isLoading.value;
  }

  //  PICK IMAGE AND UPLOAD TO CLOUDINARY
  Future<void> getImage() async {
    log.i("🔑 Loaded Cloudinary API Key: ${dotenv.env['CloudinaryApi']}");

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 60, maxWidth: 150, maxHeight: 600);

    if (image != null) {
      final imageFile = File(image.path);
      localImage.value = imageFile;
      _isUploadingImage.value = true; // Mark image as uploading

      var cloudinary = Cloudinary.fromStringUrl(
          'cloudinary://239118281366527:${dotenv.env['CloudinaryApi']}@daj7vxuyb');

      try {
        log.i("📤 Uploading image...");
        final response = await cloudinary.uploader().upload(imageFile);

        if (response != null && response.data != null) {
          if (response.data!.secureUrl != null) {
            imageUrl.value = response.data!.secureUrl!;
            log.i("✅ Image Uploaded Successfully: ${imageUrl.value}");
          } else {
            log.e("❌ Upload failed, secureUrl is null");
            Get.snackbar("Upload Error", "Failed to get image URL from Cloudinary.");
          }
        } else {
          log.e("❌ Upload failed, response data is null");
          Get.snackbar("Upload Error", "Cloudinary response is empty.");
        }
      } catch (e) {
        log.e("🚨 Cloudinary Upload Error: $e");
        Get.snackbar("Upload Error", "Something went wrong while uploading.");
      } finally {
        _isUploadingImage.value = false; // Upload complete
      }
    } else {
      log.w("❌ No image selected");
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
    if ( content.isEmpty ) {
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
    if (_isUploadingImage.value) {
      Get.snackbar("Uploading", "Please wait for image to finish uploading.");
      log.w("⏳ Waiting for image upload to complete...");
      return;
    }

    changeLoad();

    try {
      log.i("📡 Uploading Data to Firebase...");
      await FirebaseFirestore.instance.collection('blogPosts').add({
        'title': title,
        'content': content,
        'image': uploadedImageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      log.i("✅ Post Uploaded Successfully!");

      // Reset fields after submission
      titleController.value.clear();
      contentController.value.clear();
      imageUrl.value = '';
      localImage.value = null;

      // 🔄 Navigate back after submission
      Get.snackbar("Success", "Post uploaded successfully!");
      Get.offAll(() => Blog_Page());
    } catch (e) {
      log.e("🚨 Firebase Upload Error: $e");
      Get.snackbar("Error", "Failed to upload post.");
    }

    changeLoad();
  }
}
