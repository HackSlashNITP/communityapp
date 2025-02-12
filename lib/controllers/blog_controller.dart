import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BlogController  extends GetxController{
  RxBool _isLoading=false.obs;
  bool get isLoading=>_isLoading.value;
  final controller  = TextEditingController().obs;
  Rx<File?> localImage = Rx<File?>(null);
  

 
  RxString imageUrl=''.obs;

  
  void changeLoad(){
    _isLoading.value = !_isLoading.value;
  }

  // for getting image from gallery
 Future getImage() async{
  print("🔑 Loaded Cloudinary API Key: ${dotenv.env['CloudinaryApi']}");
    // initializing image picker
    final ImagePicker picker=ImagePicker();
    final XFile? image=await picker.pickImage(source: ImageSource.gallery,imageQuality: 60,maxWidth: 800,maxHeight: 600);

    if(image!=null){
     final imageFile = File(image.path);
     localImage.value = imageFile;
      
    
      var cloudinary = Cloudinary.fromStringUrl(
          'cloudinary://239118281366527:${dotenv.env['CloudinaryApi']}@daj7vxuyb');
      final response = await cloudinary.uploader().upload(imageFile);
      if (response != null &&
          response.data != null &&
          response.data!.secureUrl != null) {
        imageUrl.value = response.data!.secureUrl!;
      }
      
    }
    else{
       print("❌ No image selected");
    }
  }

  Future<void> submitPost() async{
   
    if (controller.value.text.trim().isEmpty && imageUrl.value.isEmpty){
        Get.snackbar("Error", "Post content or image is required.");
        return;
    };
     changeLoad();
     
 
   String postContent = controller.value.text;
  if(imageUrl.value.isNotEmpty){
    postContent = "\n\n![Image]($imageUrl)\n$postContent"; 
  } // Markdown format for image


   
    // adding to firebase
    await FirebaseFirestore.instance.collection('posts').add({
      'content': postContent,
      'timestamp': FieldValue.serverTimestamp(),
    });
   
  imageUrl.value = '';
  controller.value.clear();
  localImage.value = null;


    
    changeLoad();
    Get.back();
    
  }


}