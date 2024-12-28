import 'package:carousel_slider/carousel_slider.dart';
import 'package:communityapp/controllers/home_controller.dart';
import 'package:communityapp/res/colors.dart';
import 'package:communityapp/views/auth/login_view.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

class HomeView extends StatefulWidget{
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  
  double height=Get.height;
  double width=Get.width;
  
 
  BottomNavController controller=Get.put(BottomNavController());
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child:
            Container(
              color: ColorPalette.darkSlateBlue,
                child:Column(
                  children: [
                    _textField(),

                    SizedBox(height: height*0.02,),
                    
                    Container(
                      width: width,
                      height: height*0.3,
                      decoration: BoxDecoration(
                        color:ColorPalette.pureWhite,
                       borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                       

                      ), 
                      child: Column(
                        children: [
                          // carousel slider 
                          _curoselview(),
                          // dot indicator
                         Obx(()=> DotsIndicator(position:controller.CarouselController.value,dotsCount: 4,decorator: DotsDecorator(
              color: Colors.grey,
              activeColor: ColorPalette.black,
              
            ),)),
            // explore community starts from here in this column itself
                        ],
                      )
                      
                    ),
                    
                    

                    
                  ],
                ),

        ),
      ),
   );
  }
  // App baar contaning menu option, hackslash logo and switch

  PreferredSizeWidget _buildAppBar(){
    return PreferredSize(
        preferredSize: Size.fromHeight(height*0.2),
        child: Container(
          padding: EdgeInsets.only(top: height*0.05,left: width*0.03,right: width*0.02),
          color: ColorPalette.darkSlateBlue,
          
          width: width*0.9,
          height: height*0.125,
          child: Row(
            children: [
              // menu option
              Icon(Icons.menu,color: ColorPalette.pureWhite,size: height*0.052,),
              SizedBox(width: width*0.055,),
              // hackslash logo and name
              Image(image: Image.asset('assets/images/hackshashlogo.jpg').image),
              SizedBox(width: width*0.015,),
              Text('Hackslash',style: TextStyle(color: ColorPalette.pureWhite,fontSize: 28,fontWeight: FontWeight.bold),),
              SizedBox(width: width*0.12,),
             // switch for changing theme
              Obx(()=>
              SizedBox(
                width: width*0.15,
                height: height*0.055,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: 
                  Switch(value: controller.isSwitch.value,inactiveTrackColor:ColorPalette.pureWhite ,
             activeColor: ColorPalette.darkSlateBlue,activeTrackColor: ColorPalette.pureWhite,onChanged: (value){
                controller.changeSwitch();
                
              }) ,
                ),
                
              ))

            
          
            ],
          ),
        )
        
      );

  }
  // field for entering search values
  Widget _textField(){
    return Container(
      height: height*0.1,
       padding: EdgeInsets.symmetric(horizontal: width*0.035,vertical: height*0.02),
      child: TextFormField(
                        decoration: InputDecoration(
                          
                          focusColor: ColorPalette.pureWhite,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: ColorPalette.pureWhite,width: 2)
                          ),
                        fillColor: ColorPalette.pureWhite,
                        filled: true,
                        
                        
                        hintText: 'Search',
                        hintStyle: TextStyle(color: ColorPalette.darkSlateBlue,fontStyle: FontStyle.italic), 
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                              )
                            ),
                            cursorColor: ColorPalette.navyBlack,
                            
                          ),
    );
                        

  }
  // carouselview 

  Widget _curoselview(){
    return Column(
      
      children: [
        SizedBox(height: height*0.07,),
        SizedBox(
          height: height*0.2,
          width: width,
          child: CarouselSlider(
            options: CarouselOptions(
              
              enlargeCenterPage: true,
              padEnds: false,
              
              enableInfiniteScroll:false ,
              viewportFraction: 0.75 ,
              onPageChanged: (index,_)=>controller.updatePgaeIndicator(index),
            ),

            items: [
            InkWell(
              onTap: (){

              },
              child: Image(image: Image.asset('assets/images/learnToday.png',height: 200,).image,fit: BoxFit.fill,),
            ),
            
            
            InkWell(
              onTap: (){

              },
              child: _innerElement(205, 149, 57, "Which topics to", "explore", "today?"),
            ),
            InkWell(
              child: _innerElement(205, 57, 109,  "When is the", "next event ", "happening"),
              onTap: (){

              },
            ),
            InkWell(
              child:_innerElement(57,205,74, "What are the", "lastest", "projects?") ,
              onTap: (){

              },
            ),
            
          
          
          ]),
        ),
      ],
    );
  }

  // custom widget for enetering each carouselview page

  Widget _innerElement(int red,int green,int blue,String line1,String line2,String line3){
    return 
              Container(
                
                decoration: BoxDecoration(
                  color:Color.fromRGBO(red, green, blue, 0.65),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8,bottom: 5,left: 17,right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    
                    children: [
                      SizedBox(height: height*0.01,),
                      Container(
                        height: height*0.038,
                        child: Text(line1,style: TextStyle(fontSize: height*0.026,color: ColorPalette.pureWhite,fontWeight: FontWeight.w600,overflow: TextOverflow.clip))),
                      Container(
                        height: height*0.038,
                        child: Text(line2,style: TextStyle(fontSize: height*0.026,color: ColorPalette.pureWhite,fontWeight: FontWeight.w600,overflow: TextOverflow.clip))),
                      Container(
                        height: height*0.038,
                        child: Text(line3,style: TextStyle(fontSize: height*0.026,color: ColorPalette.pureWhite,fontWeight: FontWeight.w600,overflow: TextOverflow.clip))),
                        Container(
                          height: height*0.03,
                          child: Row(
                            
                            children: [
                              Flexible  (
                                
                                child: Text("Get started ",style: TextStyle(color: ColorPalette.pureWhite,fontSize: height*0.017,overflow: TextOverflow.clip))),
                              Container(
                               
                                child: Icon(Icons.arrow_forward_outlined,color: ColorPalette.pureWhite,size: height*0.017,))
                            ],
                          ),
                        )
                                
                    ],
                  ),
                ),
              );
  }
}