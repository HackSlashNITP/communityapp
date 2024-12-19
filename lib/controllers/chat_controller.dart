import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:communityapp/models/message_model.dart';

class ChatController extends GetxController {
  final String group1;
  final String channelId;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final ImagePicker _picker = ImagePicker();
  RxList<Message> messages = <Message>[].obs;

  ChatController(this.channelId,this.group1) {
    _listenForMessages();
  }


  void _listenForMessages() {
    _database.ref('channels/$channelId/$group1/messages').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        final List<Message> loadedMessages = [];
        data.forEach((key, value) {
          loadedMessages.add(Message.fromMap(Map<String, dynamic>.from(value), key));
        });
        messages.value = loadedMessages;
      }
    });
  }

  // Send a text message
  Future<void> sendTextMessage(String text, String senderName) async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final newMessage = Message(
      id: messageId,
      sender: senderName,
      message: text,
      time: DateFormat('hh:mm a').format(DateTime.now()),
      fileType: 'text',
    );
    await _database.ref('channels/$channelId/$group1/messages/$messageId').set(newMessage.toMap());
  }

  // Send an image message
  Future<void> sendImageMessage(String senderName) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final messageId = DateTime.now().millisecondsSinceEpoch.toString();
      final newMessage = Message(
        id: messageId,
        sender: senderName,
        message: base64Image,
        time: DateFormat('hh:mm a').format(DateTime.now()),
        fileType: 'image',
      );
      await _database.ref('channels/$channelId/$group1/messages/$messageId').set(newMessage.toMap());
    }
  }
}

