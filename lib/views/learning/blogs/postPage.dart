
import 'package:communityapp/controllers/blog_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class post_Page extends StatefulWidget {
  const post_Page({super.key});

  @override
  State<post_Page> createState() => _post_PageState();
}

class _post_PageState extends State<post_Page> {
  
  BlogController blogController=Get.put(BlogController());
  
  
  double height=Get.height;
  double width=Get.width;

 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _postForm(),
    );
  }
  PreferredSizeWidget _appBar(){
    return AppBar(
        centerTitle: true,
        title: Text("New Post",style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),),
        backgroundColor: Color.fromRGBO(34, 51, 69, 1.0),
      );
  }

  Widget _postForm(){
    return  Padding(padding: EdgeInsets.symmetric(horizontal: width*0.05),
      child: Column(
        children: [
         Expanded(child: TextField(
          controller: blogController.controller.value,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Write in Markdown..",
          ),
         )),
         SizedBox(height: height*0.05,),
                 Obx(() {
          if (blogController.localImage.value!=null) {
            return Column(
              children: [
                
                   Image.file(
                    blogController.localImage.value!,
                    height: height * 0.25,
                    
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                
                SizedBox(height: 10),
                Text("Selected Image", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            );
          }
           else {
            return SizedBox(); // Hide if no image selected
          }
        }),

        SizedBox(height: height * 0.02),


       
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [ Obx(()=>Container(

            height: height*0.06,
            width: width*0.7,
            child: ElevatedButton(onPressed: (){
                 blogController.isLoading? null: blogController.submitPost();
                }, child: blogController.isLoading ? const CircularProgressIndicator() : Text("Submit",style: TextStyle(fontSize:width*0.06),), ),
          )),
              IconButton(onPressed: (){
                blogController.getImage();
              }, icon: Icon(Icons.image),
              ),
             
             
         ],),
         SizedBox(height: height*0.02,)
          
         
        ],
      ),

    );
  }
}