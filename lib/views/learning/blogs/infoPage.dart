import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    double height = Get.height;
    return Scaffold(
     
      body: Container(
        padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
        child: SingleChildScrollView(
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              Text(
                "- How to Use a Blog and Write Using Markdown",
                style: TextStyle(
                    fontSize: width * 0.06, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Text(
                  "-- Getting Started with Blogging \n A blog is an online space where you can share your thoughts, insights, and expertise on various topics. To start using a blog, follow these steps:",style: TextStyle(fontSize: width*0.04,fontWeight: FontWeight.w500)),
                SizedBox(height: height*0.02),
              Text("### *Headers*",style: TextStyle(fontSize: width*0.04,fontWeight: FontWeight.w500),),
              SizedBox(height: height*0.02,),
              Text("Use # for headings: \nmarkdown\n#heading1\n##heading2 \n###heading3\n",style: TextStyle(fontSize: width*0.04,fontWeight: FontWeight.w500),),
              SizedBox(height: height*0.02,),
              Text("### *Bold and Italics*\n markdown\n **Bold Text**\n  *Italic Text*",style: TextStyle(fontSize: width*0.04,fontWeight: FontWeight.w500),),
              SizedBox(height: height*0.02,),
              Text("### *Lists*\n#### Unordered List:markdown\n- Item 1\n- Item 2\n- Sub-item 1\n",style: TextStyle(fontSize: width*0.04,fontWeight: FontWeight.w500),),
              SizedBox(height: height*0.02,),
              Text("#### Ordered List:markdown\n1. Item 1\n2. Item 2\n   1. Sub-item 1\n",style: TextStyle(fontSize: width*0.04,fontWeight: FontWeight.w500),),
              SizedBox(height: height*0.02,),
            
             

                


              
            ],
          ),
        ),
      ),
    );
  }
}
