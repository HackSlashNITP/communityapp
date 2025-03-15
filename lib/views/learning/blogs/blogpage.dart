import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communityapp/controllers/blog_controller.dart';
import 'package:communityapp/models/blog_model.dart';
import 'package:communityapp/views/learning/blogs/infoPage.dart';
import 'package:communityapp/views/learning/blogs/post_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'detailed_post_view.dart';

class Blog_Page extends StatefulWidget {
  const Blog_Page({super.key});

  @override
  State<Blog_Page> createState() => _Blog_PageState();
}

class _Blog_PageState extends State<Blog_Page> {
  double width = Get.width;
  double height = Get.height;

  String truncateWithEllipsis(String text, int cutoff) {
    return (text.length > cutoff) ? '${text.substring(0, cutoff)}...' : text;
  }

  // initalising controller
  BlogController blogController = Get.put(BlogController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF110E2B),
      appBar: appBar(),
      body: Stack(children: [
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
        Column(
          children: [
            Expanded(child: buildBlock()),
          ],
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(PostPage());
        },
        tooltip: 'Add Blog',
        splashColor: Colors.blue,
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18))),
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
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
                'Blog Page',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(width: width * 0.18),
              InkWell(
                // get info about markdown
                onTap: () {
                  Get.dialog(Dialog(
                    child: InfoPage(),
                    shadowColor: Colors.grey,
                    shape: Border.all(
                      width: 1,
                      color: Color.fromRGBO(34, 51, 69, 1.0),
                    ),
                  ));
                },
                child: Icon(
                  Icons.info_outline,
                  size: height * 0.04,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ));
  }

  Widget buildBlock() {
    return StreamBuilder<List<BlogModel>>(
      stream: blogController.getAllBlogPostsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No posts yet!"));
        }

        final blogPosts = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: blogPosts.length,
          itemBuilder: (context, index) {
            final blog = blogPosts[index];

            // Ensure non-null values
            final String title = blog.title ?? 'Untitled';
            final String author = blog.author ?? 'Anonymous';
            final String imageUrl = blog.imageUrl ?? '';
            final String content = blog.content ?? '';
            final String createdAt = blog.createdAt ?? '';

            // Format timestamp
            String formattedTimestamp = 'Unknown Date';
            if (createdAt.isNotEmpty) {
              try {
                DateTime dateTime = DateTime.parse(createdAt);
                formattedTimestamp =
                    'Posted: ${DateFormat('dd/MM/yyyy').format(dateTime)}';
              } catch (e) {
                formattedTimestamp = 'Invalid Date';
              }
            }

            return GestureDetector(
              onTap: () {
                Get.to(() => DetailedPostView(blogModel: blog));
              },
              child: Card(
                margin: EdgeInsets.symmetric(
                    vertical: height * 0.024, horizontal: width * 0.02),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                width: width * 0.3,
                                height: height * 0.2,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    FlutterLogo(
                                        size: height * 0.2), // Error fallback
                              )
                            : FlutterLogo(
                                size: height * 0.2), // Default placeholder
                      ),
                      SizedBox(width: width * 0.04),

                      // Content
                      Expanded(
                        child: SizedBox(
                          height: height * 0.2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Title (Markdown formatted)
                              RichText(
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: parseMarkdownText(title),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),

                              // Author Name
                              Text(
                                author,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),

                              // Timestamp
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  formattedTimestamp,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // code for converting markdown to text

  List<TextSpan> parseMarkdownText(String text) {
    List<TextSpan> spans = [];
    RegExp exp = RegExp(r"\*\*(.*?)\*\*"); // Match bold (**text**)
    int lastIndex = 0;

    for (Match match in exp.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(fontWeight: FontWeight.bold), // Make bold
      ));
      lastIndex = match.end;
    }
    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return spans;
  }
}
