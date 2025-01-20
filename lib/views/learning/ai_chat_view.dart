import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../controllers/ai_chat_controller.dart';

class AiChatView extends StatelessWidget {
  const AiChatView({super.key, required this.uid, required this.name});

  final String uid;
  final String name;


  @override
  Widget build(BuildContext context) {
    final user = types.User(
      id: uid,
      firstName: name,
    );
    final AiChatController controller = Get.put(AiChatController(user: user));
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => Chat(
              messages: controller.messages,
              onSendPressed: (partialText) {
                final textMessage = types.TextMessage(
                  author: controller.user,
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                  id: const Uuid().v4(),
                  text: partialText.text,
                );

                // Add user's message
                controller.addMessage(textMessage);

                // Get AI response stream
                controller.getAiResponseStream(partialText.text);
              },
              user: controller.user,
              showUserAvatars: true,
              showUserNames: true,
            )),
          ),
        ],
      ),
    );
  }
}
