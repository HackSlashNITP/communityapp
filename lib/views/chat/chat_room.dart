import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:communityapp/controllers/chat_controller.dart';
import 'package:communityapp/models/message_model.dart';
import 'package:communityapp/res/colors.dart';

class ChatScreen extends StatelessWidget {
  final String userName;
  final String channelId;
  final String group1;

  ChatScreen({
    required this.userName,
    required this.channelId,
    required this.group1,
  });

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController(channelId,group1));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: ColorPalette.brightEmeraldGreen,
        elevation: 3,
          title:
           Row(
             mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                  radius: 25,
                  backgroundColor: ColorPalette.navyBlack ,
                  backgroundImage: AssetImage('assets/images/hackshashlogo.jpg'),
                ),
              SizedBox(width: 10),
               Center(child: Text('$channelId ($group1)',
                 style: TextStyle(color: ColorPalette.navyBlack,fontWeight: FontWeight.bold,fontSize: 20),)),

            ],
          ),
      ),

      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final sortedMessages = chatController.messages.toList();
              sortedMessages.sort((a, b) => a.time.compareTo(b.time));
              return ListView.builder(
                itemCount: sortedMessages.length,
                itemBuilder: (context, index) {
                  final message = sortedMessages[index];
                  return _buildMessageItem(message, userName);
                },
              );
            }),
          ),
          _buildMessageInput(chatController),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Message message, String userName) {
    final isSentByMe = message.sender == userName;
    return Column(
      crossAxisAlignment:
      isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            isSentByMe ? "You" : message.sender,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSentByMe ? Colors.blueAccent : Colors.grey[700],
            ),
          ),
        ),
        Align(
          alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isSentByMe ? Colors.blueAccent : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.fileType == 'image')
                  Image.memory(
                    base64Decode(message.message),
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                else
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isSentByMe ? Colors.white : Colors.black,
                    ),
                  ),
                SizedBox(height: 5),
                Text(
                  message.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: isSentByMe ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput(ChatController chatController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () async {
              await chatController.sendImageMessage(userName);
            },
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                chatController.sendTextMessage(messageController.text, userName);
                messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
