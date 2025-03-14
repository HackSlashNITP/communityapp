import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    double height = Get.height;
    
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900, // Dark background

      appBar: AppBar(
        title: Text("Markdown Guide",style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromARGB(255, 54, 48, 97),
        
        centerTitle: true,
      ),

      body: Center(
        child: Container(
          width: width * 0.9,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, // Card-like background
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),

          child: SingleChildScrollView(
            child: MarkdownBody(
              data: """
# How to Use a Blog and Write Using Markdown

## Getting Started with Blogging  
A blog is an online space where you can share your thoughts, insights, and expertise on various topics.  
To start using a blog, follow these steps:

### 📝 Headers
Use `#` for headings:

### **Bold and Italics**
- **Bold Text:** `**Bold Text**`  
- *Italic Text:* `*Italic Text*`

### 📌 Lists
#### Unordered List:
- Item 1
- Item 2
  - Sub-item 1

#### Ordered List:
1. Item 1
2. Item 2
   1. Sub-item 1
              """,
              styleSheet: MarkdownStyleSheet(
                h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                h2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                p: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
