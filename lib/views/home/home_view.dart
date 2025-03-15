import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communityapp/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:communityapp/controllers/home_controller.dart';
import 'package:communityapp/res/colors.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:communityapp/models/member_model.dart';
import 'package:get/route_manager.dart';
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
          return Column(
            children: [
              Container(
                color: const Color(0xFF110E2B),
                height: 100,
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(height: 5,),
                      Container(
                        child: Row(
                          children: [
                            Spacer(),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage('assets/images/logo.jpg'),
                                  fit: BoxFit.fill,
                                )
                              ),
                            ),
                            SizedBox(width: 5,),
                            Container(
                              child: Text("Hackslash", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Center(
                        child: Text("moz://a", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: const Color(0xFF110E2B),
                  child: SingleChildScrollView(
                    child: Container(
                      //height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: ColorPalette.pureWhite,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      child: Column(
                        children: [
                          _topHead("Upcoming Events"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: FutureBuilder<List<EventOption>>(
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
                                  height: isLandscape ? height * .65 : height * 0.33,
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
                          ),
                          _topHead("Explore Community"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              // width: isLandscape ? constraints.maxWidth *0.5 :375,
                              height: isLandscape ? constraints.maxHeight * 0.6 : 130,
                              child: ScrollConfiguration(
                                behavior: const ScrollBehavior().copyWith(
                                  physics: const BouncingScrollPhysics(),
                                ),
                                child: myCommunityList(isLandscape, height, width),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
              // color: const Color(0xff223345),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
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
          color: const Color(0xFF110E2B),
          width: width * 0.9,
          height: isLanscape ? height * .2 : height * 0.125,
          child: Row(
            children: [
              // menu option
              Icon(
                Icons.info_outline,
                color: ColorPalette.pureWhite,
                size: isLanscape ? height * .03 : height * 0.03,
              ),

              SizedBox(
                width: isLanscape ? width * .02 : width * 0.015,
              ),
              Text(
                'About us',
                style: TextStyle(
                    color: ColorPalette.pureWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Icon(
                Icons.notifications,
                color: ColorPalette.pureWhite,
                size: isLanscape ? height * .03 : height * 0.03,
              ),
            ],
          ),
        )
    );
  }

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
                              color: const Color(0xFFFFF5E1).withOpacity(0.8),
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
