import 'package:flutter/material.dart';

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
    final List<CommunityOption> options = [
      //This is a list of options for the community(created )
      //yeh hai apan ke community options hai
      //run time mein data store hoga
      CommunityOption(
        //constructor ka purna istemal
        title: 'WEB\nDEVELOPMENT',
        icon: Icons.language,
        route: '/web-development',
      ),
      CommunityOption(
        title: 'ANDROID\nDEVELOPMENT',
        icon: Icons.android,
        route: '/android-development',
      ),
      CommunityOption(
        title: 'ARTIFICIAL\nINTELLIGENCE',
        icon: Icons.psychology,
        route: '/ai',
      ),
      CommunityOption(
        title: 'DATA\nSTRUCTURES',
        icon: Icons.account_tree,
        route: '/data-structures',
      ),
    ];

    final List<EventOption> events = [
      EventOption(
        title: 'Anvikshiki',
        image: 'assets/meme.png',
        venue: 'Venue: TBA',
        time: 'Time: TBA',
        route: '/anvikshiki',
      ),
      EventOption(
        title: 'Hacktober Fest\nInfo Session',
        image: 'assets/meme01.jpg',
        venue: 'Venue: TBA',
        time: 'Time: TBA',
        route: '/hacktober',
      ),
      // Add more events as needed
    ];
    final width = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: _buildAppBar(),
      body: LayoutBuilder(
          builder: (context, constraints) {
        return SingleChildScrollView(
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
                        Padding(
                          padding: EdgeInsets.only(
                              top: 32.0, left: 16.0, right: 16.0, bottom: 16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF223345),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Explore Community',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Divider(
                                    color: Colors.black54,
                                    thickness: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: isLandscape ? constraints.maxHeight * 0.6 : 160,
                          child: ScrollConfiguration(
                            behavior: const ScrollBehavior().copyWith(
                              physics: const BouncingScrollPhysics(),
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                return CommunityCard(option: options[index]);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20), // Spacing between sections
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 32.0, left: 16.0, right: 16.0, bottom: 16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF223345),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Upcoming Events',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Divider(
                                    color: Colors.black54,
                                    thickness: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: isLandscape ? constraints.maxHeight * 0.7 : 280,
                          child: ScrollConfiguration(
                            behavior: const ScrollBehavior().copyWith(
                              physics: const BouncingScrollPhysics(),
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                return EventCard(event: events[index]);
                              },
                            ),
                          ),
                        ),
                      ],
                    )
        
                ),
        
        
        
        
              ],
            ),
        
          ),
        );
          }
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
class CommunityCard extends StatelessWidget {
  final CommunityOption option;
  const CommunityCard({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, option.route),
        child: Container(
          width: 140,
          height: isLandscape ? 120 : null,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                option.icon,
                size: isLandscape ? 24 : 30,
                color: Colors.black87,
              ),
              const SizedBox(height: 8),
              Text(
                option.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isLandscape ? 12 : 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Event Card Widget
class EventCard extends StatelessWidget {
  final EventOption event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, event.route),
        child: Container(
          width: 280, // Wider than community cards
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  event.image,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.venue,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      event.time,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommunityOption {
  final String title;
  final IconData icon;
  final String route;

  CommunityOption({
    required this.title,
    required this.icon,
    required this.route,
  });
}

class WebDevelopmentScreen extends StatelessWidget {
  const WebDevelopmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Team 405 waale jyada hi hawa me udhte hain!')),
    );
  }
}

class AndroidDevelopmentScreen extends StatelessWidget {
  const AndroidDevelopmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text('FLutter is the best!(apne muh se tarif not good)')),
    );
  }
}

class AIScreen extends StatelessWidget {
  const AIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Generating.....')),
    );
  }
}

class DataStructuresScreen extends StatelessWidget {
  const DataStructuresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Anshuman Gangwar is a good boy!')),
    );
  }
}

class EventOption {
  final String title;
  final String image;
  final String venue;
  final String time;
  final String route;

  const EventOption({
    required this.title,
    required this.image,
    required this.venue,
    required this.time,
    required this.route,
  });
}

class AnvikshikiScreen extends StatelessWidget {
  const AnvikshikiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Bawal macha diye the ekdum')),
    );
  }
}

class HacktoberScreen extends StatelessWidget {
  const HacktoberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Hacktober Fest ')),
    );
  }
}
