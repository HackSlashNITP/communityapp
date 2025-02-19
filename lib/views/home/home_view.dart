import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communityapp/models/community_model.dart';
import 'package:communityapp/models/course_model.dart';

import 'package:communityapp/views/learning/roadmap_view.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:communityapp/controllers/home_controller.dart';
import 'package:communityapp/res/colors.dart';

import 'package:dots_indicator/dots_indicator.dart';

import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:communityapp/models/member_model.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  BottomNavController controller = Get.put(BottomNavController());
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return OrientationBuilder(builder: (context, orientation) {
      bool isLandscape = orientation == Orientation.landscape;
      return Scaffold(
        appBar: _buildAppBar(isLandscape, height, width),
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxHeight == 0 || constraints.maxWidth == 0) {
            return SizedBox();
          }
          return SingleChildScrollView(
            child: Container(
              color: ColorPalette.pureWhite,
              child: Column(
                children: [
                  Container(
                    color: ColorPalette.darkSlateBlue,
                    child: Column(
                      children: [
                        _textField(height, width, isLandscape),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Container(
                            // width: width,
                            // height: isLandscape ? height * .4 : height * 0.28,
                            decoration: BoxDecoration(
                              color: ColorPalette.pureWhite,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                            ),
                            child: Expanded(
                              child: Column(
                                children: [
                                  // carousel slider
                                  _curoselview(isLandscape, height, width),

                                  // dot indicator
                                  Obx(() => DotsIndicator(
                                        position: controller.CarouselController.value,
                                        dotsCount: 4,
                                        decorator: DotsDecorator(
                                          color: Colors.grey,
                                          activeColor: ColorPalette.black,
                                        ),
                                      )),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),

                  _topHead("Explore Community"),
                  SizedBox(
                    height: isLandscape ? constraints.maxHeight * 0.6 : 160,
                    child: ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(
                        physics: const BouncingScrollPhysics(),
                      ),
                      child: myCommunityList(isLandscape, height, width),
                    ),
                  ),
                  SizedBox(height: 2), // Spacing between sections
                  _topHead("Upcoming Events"),
                  FutureBuilder<List<EventOption>>(
                    future: fetchAllEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Loading spinner while fetching data
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        // Display an error if one occurred
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      // If we get here, data is loaded or empty
                      final events = snapshot.data ?? [];
                      if (events.isEmpty) {
                        return const Center(child: Text('No events found.'));
                      }

                      // Build your horizontal list using the loaded events
                      return SizedBox(
                        height: isLandscape ? height * .65 : height * 0.36,
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior().copyWith(
                            physics: const BouncingScrollPhysics(),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: events.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return EventCard(
                                event: events[index],
                                isLandscape: isLandscape,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 2), // Spacing between sections
                  _topHead("Recent Courses"),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    child: FutureBuilder<List<CourseModel>>(
                      future: fetchAllCourses(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        final courses = snapshot.data ?? [];

                        return ListView.builder(
                          // ...
                          itemCount: courses.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return CourseCard(
                              course: courses[index],
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              isLandscape: isLandscape,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _topHead(String title) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 32.0, left: 16.0, right: 16.0, bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xff223345),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.black54,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  // App baar contaning menu option, hackslash logo and switch

  PreferredSizeWidget _buildAppBar(
      bool isLanscape, double height, double width) {
    return PreferredSize(
        preferredSize: Size.fromHeight(isLanscape ? height * .6 : height * 0.2),
        child: Container(
          padding: EdgeInsets.only(
              top: height * 0.05, left: width * 0.03, right: width * 0.02),
          color: ColorPalette.darkSlateBlue,
          width: width * 0.9,
          height: isLanscape ? height * .2 : height * 0.125,
          child: Row(
            children: [
              // menu option
              Icon(
                Icons.menu,
                color: ColorPalette.pureWhite,
                size: isLanscape ? height * .07 : height * 0.05,
              ),
              SizedBox(
                width: width * 0.05,
              ),
              // hackslash logo and name
              Image(
                image: Image.asset('assets/images/logo.jpg').image,
                height: isLanscape ? height * .07 : height * 0.05,
                width: width * 0.1,
              ),
              SizedBox(
                width: isLanscape ? width * .02 : width * 0.015,
              ),
              Text(
                'Hackslash',
                style: TextStyle(
                    color: ColorPalette.pureWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              // switch for changing theme
              Obx(() => SizedBox(
                    width: isLanscape ? width * .08 : width * 0.12,
                    height: isLanscape ? height * .1 : height * 0.04,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Switch(
                          value: controller.isSwitch.value,
                          inactiveTrackColor: ColorPalette.pureWhite,
                          activeColor: ColorPalette.darkSlateBlue,
                          activeTrackColor: ColorPalette.pureWhite,
                          onChanged: (value) {
                            controller.changeSwitch();
                          }),
                    ),
                  ))
            ],
          ),
        ));
  }

  // field for entering search values
  Widget _textField(double height, double width, bool isLanscape) {
    return Container(
      height: isLanscape ? height * .15 : height * 0.09,
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.035, vertical: height * 0.02),
      child: TextFormField(
        decoration: InputDecoration(
            focusColor: ColorPalette.pureWhite,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: ColorPalette.pureWhite, width: 2)),
            fillColor: ColorPalette.pureWhite,
            filled: true,
            hintText: 'Search',
            hintStyle: TextStyle(
              color: ColorPalette.darkSlateBlue,
              fontStyle: FontStyle.italic,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        cursorColor: ColorPalette.navyBlack,
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
  // carouselview

  Widget _curoselview(bool isLandscape, double height, double width) {
    return Column(
      children: [
        SizedBox(
          height: isLandscape ? height * 0.04 : height * 0.04,
        ),
        SizedBox(
          height: isLandscape ? height * .3 : height * 0.2,
          width: MediaQuery.sizeOf(context).width,
          child: CarouselSlider(
              options: CarouselOptions(
                  enlargeCenterPage: true,
                  padEnds: false,
                  enableInfiniteScroll: false,
                  viewportFraction: isLandscape ? .85 : 0.75,
                  onPageChanged: (index, _) =>
                      controller.updatePgaeIndicator(index.toDouble()),
                  autoPlay: true,
                  pauseAutoPlayOnTouch: true),
              items: [
                // InkWell(
                //   onTap: () {},
                //   child: Image(
                //     height: isLandscape ? height * .3 : height * 0.2,
                //     width: isLandscape ? width * .85 : width * 0.75,
                //     image: Image.asset(
                //       'assets/images/learnToday.png',
                //     ).image,
                //     fit: BoxFit.contain,
                //   ),
                // ),
                InkWell(
                  onTap: () {},
                  child: _innerElement(100, 149, 237, "What would you",
                      "like to learn", "today?", height, width, isLandscape),
                ),
                InkWell(
                  onTap: () {},
                  child: _innerElement(205, 149, 57, "Which topics to",
                      "explore", "today?", height, width, isLandscape),
                ),
                InkWell(
                  child: _innerElement(205, 57, 109, "When is the",
                      "next event ", "happening", height, width, isLandscape),
                  onTap: () {},
                ),
                InkWell(
                  child: _innerElement(57, 205, 74, "What are the", "lastest",
                      "projects?", height, width, isLandscape),
                  onTap: () {},
                ),
              ]),
        ),
      ],
    );
  }

  // custom widget for enetering each carouselview page

  Widget _innerElement(int red, int green, int blue, String line1, String line2,
      String line3, double height, double width, bool isLandscape) {
    return Container(
      width: width * 1,
      height: isLandscape ? height * .4 : height * 0.2,
      decoration: BoxDecoration(
          color: Color.fromRGBO(red, green, blue, 0.65),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 5, left: 17, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: height * 0.01,
            ),
            Container(
                height: isLandscape ? height * .05 : height * 0.038,
                child: Text(line1,
                    style: TextStyle(
                        fontSize: isLandscape ? height * .04 : height * 0.026,
                        color: ColorPalette.pureWhite,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.clip))),
            Container(
                height: isLandscape ? height * .05 : height * 0.038,
                child: Text(line2,
                    style: TextStyle(
                        fontSize: isLandscape ? height * .04 : height * 0.026,
                        color: ColorPalette.pureWhite,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.clip))),
            Container(
                height: isLandscape ? height * .05 : height * 0.038,
                child: Text(line3,
                    style: TextStyle(
                        fontSize: isLandscape ? height * .04 : height * 0.026,
                        color: ColorPalette.pureWhite,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.clip))),
            Container(
              height: isLandscape ? height * .05 : height * 0.038,
              child: Row(
                children: [
                  Flexible(
                      child: Text("Get started ",
                          style: TextStyle(
                              color: ColorPalette.pureWhite,
                              fontSize:
                                  isLandscape ? height * .022 : height * 0.017,
                              overflow: TextOverflow.clip))),
                  Container(
                      child: Icon(
                    Icons.arrow_forward_outlined,
                    color: ColorPalette.pureWhite,
                    size: isLandscape ? height * .02 : height * 0.017,
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventOption event;
  final bool isLandscape;
  const EventCard({super.key, required this.event, required this.isLandscape});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        // We'll push a detail page with the same Hero tag
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EventDetailPage(event: event),
            ),
          );
        },
        child: Hero(
          // Use a unique tag. This could be event.id, event.title, etc.
          tag: event.title,
          child: Container(
            width: 280,
            // height: Get.height * 2,
            //height: Get.height * .5, // Wider than community cards
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero animations look great if we also match the shape here:
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    event.image,
                    //height: 140,
                    height: isLandscape ? Get.height * .35 : Get.height * .21,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  child: Padding(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EventDetailPage extends StatelessWidget {
  final EventOption event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return OrientationBuilder(builder: (context, orientation) {
      bool isLandscape = orientation == Orientation.landscape;
      return Scaffold(
        // Make the background or AppBar fit your style
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(event.title),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Hero(
            tag: event.title,
            child: Material(
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isLandscape ? Row(
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                            child: Image.network(
                              event.image,
                             // width: double.infinity,
                              //height: isLandscape ? height * .5 : height * .3,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Venue: ${event.venue}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Time: ${event.time}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Event Info \n ' + event.eventInfo,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            event.image,
                            width: double.infinity,
                            height: 300,
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
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Venue: ${event.venue}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Time: ${event.time}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Event Info \n ' + event.eventInfo,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

Widget myCommunityList(bool isLandscape, double height, double width) {
  return FutureBuilder<List<CommunityModel>>(
      future: fetchAllCommunity(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final data = snapshot.data!;

            return SizedBox(
              height: 120,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    CommunityModel currCommunity = data[index];
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(CommunityView(myComm: currCommunity));
                          },
                          child: Container(
                            height: isLandscape ? height * .45 : height * 0.26,
                            width: isLandscape ? width * .25 : width * 0.45,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Color(0xffE3E3E3),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  currCommunity.logo!,
                                  height: 85,
                                  width: 85,
                                ),
                                Text(
                                  currCommunity.category,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    );
                  }),
            );
          } else {
            return Text("Some error occured");
          }
        }
        return Text("Some error occured");
      });
}

Future<List<CommunityModel>> fetchAllCommunity() async {
  final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('Communities').get();
  return snapshot.docs
      .map((doc) => CommunityModel.fromMap(doc.data() as Map<String, dynamic>))
      .toList();
}

Future<List<CourseModel>> fetchAllCourses() async {
  final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('Courses').get();

  return snapshot.docs
      .map((doc) => CourseModel.fromJson(doc.data() as Map<String, dynamic>))
      .toList();
}

PreferredSizeWidget communityAppBar(String name) {
  return AppBar(
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    title: Text(name),
  );
}

class CommunityView extends StatelessWidget {
  final CommunityModel myComm;
  CommunityView({super.key, required this.myComm});
  Future<void> _launchURL(String link) async {
    final Uri url = Uri.parse(link);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    int count = ((myComm.members!.length) ~/ 2);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: communityAppBar(myComm.category),
      body: OrientationBuilder(builder: (context, orinetation) {
        bool isPortrait = orinetation == Orientation.portrait;
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isPortrait ? 25 : 45),
                child: isPortrait
                    ? Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Image.network(
                              myComm.image,
                              height: height * .3,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            //height: Get.height * .23,
                            //width: MediaQuery.of(context).size.width * .85,
                            decoration: const BoxDecoration(
                              color: Color(0xffF1F1F1),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    myComm.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: Get.height * .01,
                                  ),
                                  Text(
                                    myComm.info ?? "",
                                    style: TextStyle(fontSize: 13.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Expanded(
                        child: SizedBox(
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                child: Image.network(
                                  myComm.image,
                                  height: height * .6,
                                  width: width * .35,
                                  //width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  //height: Get.height * .23,
                                  //width: MediaQuery.of(context).size.width * .85,
                                  height: height * .6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffF1F1F1),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          myComm.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: Get.height * .01,
                                        ),
                                        Text(
                                          myComm.info ?? "",
                                          style: TextStyle(fontSize: 13.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: Get.height * .02,
              ),
              SizedBox(
                height: Get.height * .02,
              ),
              Text(
                "Coordinators",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
              ),
              SizedBox(
                height: Get.height * .01,
              ),
              SizedBox(
                //height: Get.height * .02,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: myComm.coordinators!.length,
                    itemBuilder: (context, index) {
                      MemberModel currCoordinator = myComm.coordinators![index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (currCoordinator.linkedin != null) {
                                _launchURL(currCoordinator.linkedin!);
                              }
                            },
                            child: currCoordinator.image == null
                                ? Image.network(
                                    "https://static.vecteezy.com/system/resources/thumbnails/002/002/403/small/man-with-beard-avatar-character-isolated-icon-free-vector.jpg")
                                : photoFrame(currCoordinator.image!),
                          ),
                          Text(currCoordinator.name),
                          Text(
                            currCoordinator.position,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: Get.height * .02,
                          ),
                        ],
                      );
                    }),
              ),
              SizedBox(height: Get.height * 0.05),
              Text(
                "Members",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
              ),
              SizedBox(
                height: Get.height * .02,
              ),
              ListView.builder(
                  itemCount: count,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    int curr_index = index * 2;
                    MemberModel firstMember = myComm.members![curr_index];
                    MemberModel secondMember = myComm.members![curr_index + 1];
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (firstMember.linkedin != null) {
                                      _launchURL(firstMember.linkedin!);
                                    }
                                  },
                                  child: firstMember.image == null
                                      ? Image.network(
                                          "https://static.vecteezy.com/system/resources/thumbnails/002/002/403/small/man-with-beard-avatar-character-isolated-icon-free-vector.jpg")
                                      : photoFrame(firstMember.image!),
                                ),
                                SizedBox(
                                  height: Get.height * .01,
                                ),
                                Text(firstMember.name),
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (secondMember.linkedin != null) {
                                      _launchURL(secondMember.linkedin!);
                                    }
                                  },
                                  child: secondMember.image == null
                                      ? Image.network(
                                          "https://static.vecteezy.com/system/resources/thumbnails/002/002/403/small/man-with-beard-avatar-character-isolated-icon-free-vector.jpg")
                                      : photoFrame(secondMember.image!),
                                ),
                                SizedBox(
                                  height: Get.height * .01,
                                ),
                                Text(secondMember.name),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * .02,
                        ),
                      ],
                    );
                  }),
              myComm.members!.length % 2 == 0
                  ? SizedBox()
                  : Column(
                      children: [
                        photoFrame(
                            myComm.members![myComm.members!.length - 1].image!),
                        SizedBox(
                          height: Get.height * .01,
                        ),
                        Text(myComm.members![myComm.members!.length - 1].name),
                      ],
                    ),
              SizedBox(
                height: Get.height * .02,
              ),
            ],
          ),
        );
      }),
    );
  }
}

Widget photoFrame(String path) {
  return CircleAvatar(
    radius: 70,
    backgroundColor: Color(0xff00FF9D),
    child: CircleAvatar(
      backgroundColor: Colors.white,
      radius: 68,
      child: CircleAvatar(
        radius: 62,
        backgroundImage: NetworkImage(path),
      ),
    ),
  );
}

class EventOption {
  final String title;
  final String image;
  final String venue;
  final String time;
  final String route;
  final String eventInfo;

  const EventOption({
    required this.title,
    required this.image,
    required this.venue,
    required this.time,
    required this.route,
    required this.eventInfo,
  });
  factory EventOption.fromFirestore(Map<String, dynamic> data, String docId) {
    return EventOption(
        title: data['title'] ?? docId,
        image: data['imageUrl'] ?? 'assets/images/logo.png',
        venue: 'Venue: ' + data['venue'] ?? 'Venue: TBA',
        time: 'Time: ' + data['time'] ?? 'Time: TBA',
        route: '/defaultRoute',
        eventInfo: data['eventInfo'] ?? 'Will Update Soon!');
  }
}

Future<List<EventOption>> fetchAllEvents() async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('events').get();

  // Map each document to an EventOption
  return querySnapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventOption.fromFirestore(data, doc.id);
  }).toList();
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

class Courses {
  final String title;
  final String subtitle;
  final String image;

  Courses({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  // factory constructor for Firestore, if needed
  factory Courses.fromFirestore(Map<String, dynamic> data, String docId) {
    return Courses(
      title: data['title'] ?? docId,
      subtitle: data['moreInfo'] ?? '',
      image: data['imageUrl'] ?? 'assets/images/default.png',
    );
  }
}

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final double width;
  final double height;
  final bool isLandscape;
  const CourseCard({
    Key? key,
    required this.course,
    required this.width,
    required this.height,
    required this.isLandscape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // On tap, navigate to detail page with Hero transition
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CourseDetailPage(course: course),
          ),
        );
      },
      child: Hero(
        tag: course.title, // must match the detail screen Hero tag
        child: Container(
          // styling similar to your original code
          width: isLandscape ? width * 1 : width * 0.9,
          height: isLandscape ? height * .2 : height * 0.11,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  course.image,
                  height: isLandscape ? height * .22 : height * 0.13,
                  width: width * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5),
              // TEXT
              Expanded(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title (maxLines=2)
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                      ),
                      // Subtitle (maxLines=3)
                      Text(
                        course.subtitle,
                        style: const TextStyle(
                          fontSize: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  final CourseModel course;

  const CourseDetailPage({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Hero(
          tag: course.title, // must match the list page
          child: Material(
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Container(
                // Make it fill horizontally if you wish
                width: size.width * 0.9,
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        course.image,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Course text
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            course.subtitle,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          // extraInfo can be displayed in full here
                          if (course.subtitle != null &&
                              course.subtitle!.isNotEmpty) ...[
                            const Text(
                              "More Info:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              course.subtitle,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Get.to(MyRoadMapScreen(myCourse: course));
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.grey[200])),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("RoadMap"),
                            Icon(Icons.keyboard_arrow_right_outlined)
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
