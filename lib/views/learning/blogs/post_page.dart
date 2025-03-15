import 'package:communityapp/controllers/blog_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  BlogController blogController = Get.put(BlogController());

  double height = Get.height;
  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E3A59), Color(0xFF110E2B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            children: [
              Expanded(child: _postForm()),
              SizedBox(height: 20),
              _bottomActions(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Color.fromARGB(255, 56, 50, 112),
      title: Text("New Post",
          style: TextStyle(
              color: Colors.grey, fontSize: 22, fontWeight: FontWeight.w600)),
    );
  }

  Widget _postForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _inputField(
              "Title", "Enter Title...", blogController.titleController.value),
          SizedBox(height: height * 0.02),
          _inputField("Content", "Write content in Markdown...",
              blogController.contentController.value,
              maxLines: 5),
          SizedBox(height: height * 0.03),
          _imagePreview(),
        ],
      ),
    );
  }

  Widget _inputField(
      String label, String hint, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _imagePreview() {
    return Obx(() {
      if (kIsWeb && blogController.webImageBytes.value != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            blogController.webImageBytes.value!,
            height: height * 0.25,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      } else if (!kIsWeb && blogController.localImage.value != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            blogController.localImage.value!,
            height: height * 0.25,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  Widget _bottomActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FloatingActionButton(
          onPressed: () async {
            await blogController.getImage();
          },
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.image, color: Colors.white),
        ),
        SizedBox(
          width: width * 0.7,
          child: Obx(() => ElevatedButton(
                onPressed: blogController.isLoading.value
                    ? null
                    : blogController.submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: blogController.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Submit",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
              )),
        ),
      ],
    );
  }
}
