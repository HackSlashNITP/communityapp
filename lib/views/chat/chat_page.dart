import 'package:communityapp/controllers/chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatPage extends StatefulWidget {
  final String channelId;
  final String channelName;
  final types.User user;
  final String username;

  const ChatPage({
    super.key,
    required this.channelId,
    required this.user,
    required this.channelName,
    required this.username,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final ChatController _controller;

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    String userid = auth.currentUser?.uid ??
        "hacker"; //To find unique user id for each user
    _controller = Get.put(ChatController(
        channelId: widget.channelId,
        username: auth.currentUser?.displayName ?? widget.username,
        user: widget.user,
        userId: userid));
  }

  @override
  void dispose() {
    // Dispose of the ChatController when leaving the channel
    Get.delete<ChatController>();
    super.dispose();
  }

  void showBottomSheet() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: <Widget>[
            IconButton(
                onPressed: _controller.handleImageSelection,
                icon: Icon(Icons.image)),
            IconButton(
                onPressed: _controller.handleFileSelection,
                icon: Icon(Icons.file_copy)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.channelName,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() => Chat(
            messages: _controller.messagesList.toList(),
            onAttachmentPressed: showBottomSheet,
            onMessageTap: _controller.handleMessageTap,
            onSendPressed: _controller.handleSendPressed,
            onPreviewDataFetched: _controller.handlePreviewDataFetched,
            showUserAvatars: true,
            showUserNames: true,
            user: _controller.user,
          )),
    );
  }
}
