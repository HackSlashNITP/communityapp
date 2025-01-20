
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:communityapp/views/chat/meeting_view.dart';
import 'package:communityapp/controllers/meeting_controller.dart';

import '../../widgets/animatedbuttonbar.dart';

class meetingpage extends StatefulWidget {
  final String username;
  meetingpage({required this.username});
  @override
  State<meetingpage> createState() => _meetingpageState();
}

class _meetingpageState extends State<meetingpage> {
  final TextEditingController _channelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoCallController());

    return Scaffold(
      appBar: AppBar(title: Text("hackslash meeting room")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _channelController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Meeting ID",
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final meetingId = _channelController.text.trim();
                if (meetingId.isNotEmpty) {
                  Get.to(()=>VideoCallScreen(username: widget.username,));
                  controller.fetchTokenAndJoinChannel(meetingId);
                } else {
                  Get.snackbar("Error", "Please enter a valid Meeting ID.");
                }
              },
              child: Text("Join Meeting"),
            ),
          ],
        ),
      ),
    );
  }
}
