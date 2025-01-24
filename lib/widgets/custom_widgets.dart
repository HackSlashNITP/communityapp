import 'package:communityapp/views/chat/chat_view.dart';
import 'package:communityapp/views/chat/meeting_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:communityapp/views/home/home_view.dart';
import 'package:communityapp/controllers/home_controller.dart';
import 'package:communityapp/views/learning/learning_view.dart';
import 'package:communityapp/views/profile/profile_view.dart';

class MainView extends StatelessWidget {
  final String userid;
  final BottomNavController bottomNavController = Get.put(BottomNavController());
  MainView({super.key, 
    required this.userid,
});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeView(),
<<<<<<< HEAD
      ChatView(username: userid), //switch with chat page
      LearningView(),
=======
      ChatView(username: userid),
      meetingpage(username: userid),//switch with chat page
      LearningPage(),
>>>>>>> 571a34911d72b3ee5c0ae11b03a6fcc0598bc803
      ProfileView(username: userid),
    ];
    return Scaffold(
      body: Obx(() => screens[bottomNavController.selectedIndex.value]),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: bottomNavController.selectedIndex.value,
          onTap: (index) => bottomNavController.changeIndex(index),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.meeting_room_outlined),
              label: 'meet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Learning',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }
}
