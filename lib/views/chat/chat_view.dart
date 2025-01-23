import 'package:communityapp/controllers/chatview_controller.dart';
import 'package:communityapp/services/auth_service.dart';
import 'package:communityapp/views/chat/chat_page.dart';
import 'package:communityapp/widgets/animatedbuttonbar.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:communityapp/widgets/groupbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatView extends StatefulWidget {
  final String username;

  const ChatView({super.key, required this.username});

  @override
  ChatViewState createState() => ChatViewState();
}

class ChatViewState extends State<ChatView> {
  late final ChatviewController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChatviewController(username: widget.username));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_2_rounded, size: 35),
            SizedBox(width: 20),
            Text(
              "Community",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
            ),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedButtonBar(username: widget.username),
            const SizedBox(height: 40),
            Obx(() => Expanded(
                  // Wrap the ListView.builder with Expanded
                  child: ListView.builder(
                    itemCount: controller.groups.length,
                    itemBuilder: (context, index) {
                      final group = controller.groups[index];
                      return Column(
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                final name = AuthService.getDisplayName();
                                Get.to(() => ChatPage(
                                    username: widget.username,
                                    channelId:
                                        controller.groups[index].id.toString(),
                                    channelName: controller.groups[index].name
                                        .toString(),
                                    user: types.User(
                                        id: widget.username, firstName: name)));
                              },
                              child: GroupBox(
                                avatar: group.avatar.toString(),
                                channelName: group.name.toString(),
                                unreads: group.unreads!.toInt(),
                                lastMessage:
                                    group.lastmessage!.message.toString(),
                                sender: group.lastmessage!.sender.toString(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
