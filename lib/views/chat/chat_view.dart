import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_room.dart';
import 'package:communityapp/res/colors.dart';

class chat_view extends StatelessWidget {

  final String username;
  chat_view({
    required this.username,
});
  void _showGroupDialog(BuildContext context, String channelId, String userName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.to(() => ChatScreen(
                    userName: username,
                    channelId: channelId,
                    group1: '1st year',
                  ));
                },
                child: Text('1st Year'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.to(() => ChatScreen(
                    userName: username,
                    channelId: channelId,
                    group1: '2nd year',
                  ));
                },
                child: Text('2nd Year'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.to(() => ChatScreen(
                    userName: username,
                    channelId: channelId,
                    group1: '3rd year',
                  ));
                },
                child: Text('3rd Year'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Welcome to HackSlash')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              SizedBox(height: 20),
              Text(
                'Select Your Team',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ...[
                {'name': 'Team Nougat', 'id': 'flutter'},
                {'name': 'Team 405 Found', 'id': 'web'},
                {'name': 'Team SIGSTP', 'id': 'DSA'},
                {'name': 'Team CipherSync', 'id': 'Blockchain'},
                {'name': 'Team Pixel Byte', 'id': 'UI/UX'},
                {'name': 'Team GrayInterface', 'id': 'ML'},
                {'name': 'Team PR & Event', 'id': 'PR & Event'},
                {'name': 'Team Content & Social Media', 'id': 'Content & Social Media'},
                {'name': 'Office Bearers', 'id': 'Office Bearers'},
                {'name': 'Queries', 'id': 'Queries'},
              ].map((team) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ElevatedButton(
                    onPressed: () {

                        if (team['id'] == 'Office Bearers'|| team['id'] == 'Queries') {
                          Get.to(() => ChatScreen(
                            userName: username,
                            channelId: team['id']!,
                            group1: 'Main',
                          ));
                        } else {
                          _showGroupDialog(context, team['id']!, username);
                        }

                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/images/hackshashlogo.jpg'),
                          backgroundColor: ColorPalette.navyBlack,
                        ),
                        SizedBox(width: 10),
                        Text(
                          team['name']!,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
