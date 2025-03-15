import 'package:communityapp/models/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DetailedPostView extends StatelessWidget {
  DetailedPostView({super.key, required this.blogModel});

  final BlogModel blogModel;
  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    double height = Get.height;

    return Scaffold(
      backgroundColor: Color(0xFF110E2B),
      appBar: appBar(),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: SvgPicture.asset('assets/svgs/box.svg'),
          ),
          Positioned(
            right: 0,
            top: height * 0.13,
            child: SvgPicture.asset('assets/svgs/box.svg'),
          ),
          Positioned(
            top: height * 0.4,
            left: 0,
            child: SvgPicture.asset('assets/svgs/rectangle.svg'),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  blogModel.title ?? "Title",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),

                // Image (Handles null imageUrl)
                if (blogModel.imageUrl != null &&
                    blogModel.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      blogModel.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.broken_image,
                          size: 80,
                          color: Colors.grey),
                    ),
                  ),
                SizedBox(height: 16),

                // Description (Expands dynamically)
                _descriptionUI()
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget appBar() {
    double width = Get.width;
    double height = Get.height;
    return PreferredSize(
        preferredSize: Size.fromHeight(height * 0.2),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF110E2B),
          ),
          padding: EdgeInsets.only(
              top: height * 0.05, left: width * 0.03, right: width * 0.02),
          width: width * 0.9,
          height: height * 0.125,
          child: Row(
            children: [
              // menu option
              SizedBox(width: width * 0.27),
              Text(
                'HackSlash',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(width: width * 0.18),
            ],
          ),
        ));
  }

  Widget _descriptionUI() {
    return MarkdownBody(
      data: blogModel.content ?? "No description available.",
      styleSheet: MarkdownStyleSheet(
        // 🌟 General Paragraph Text
        p: const TextStyle(fontSize: 18, color: Colors.white70),

        // 🏆 Headers - Adjusted for Dark Blue Background
        h1: const TextStyle(
            fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        h2: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB0E0E6)), // Light Blue
        h3: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFD700)), // Gold/Yellow
        h4: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF87CEFA)), // Sky Blue
        h5: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF98FB98)), // Light Green
        h6: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFA07A)), // Light Salmon

        // ✅ Bold and Italic Styling
        strong:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        em: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white70),

        // 🔗 Hyperlink Styling
        a: const TextStyle(
            color: Color(0xFFFFA500),
            decoration: TextDecoration.underline), // Orange Links

        // 📌 Lists
        listBullet: const TextStyle(
            fontSize: 18, color: Color(0xFF87CEFA)), // Light Sky Blue

        // 🗒️ Blockquote Styling
        blockquote: TextStyle(
          fontSize: 18,
          fontStyle: FontStyle.italic,
          color: Colors.grey[300],
          decoration: TextDecoration.underline,
        ),

        // 🖋️ Code Block Styling
        code: const TextStyle(
          fontSize: 16,
          fontFamily: 'monospace',
          color: Color(0xFFFFA07A), // Light Salmon
          backgroundColor: Color(0xFF2E2E2E), // Dark Gray Background
        ),

        // 📤 Horizontal Line (Divider)
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.5, color: Colors.white70),
          ),
        ),

        // 📎 Table Styling
        tableHead: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
        tableBody: const TextStyle(fontSize: 16, color: Colors.white70),
      ),
    );
  }
}
