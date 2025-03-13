import 'dart:async';
import 'dart:io';
import 'package:communityapp/models/message_model.dart';
import 'package:communityapp/utils/logging.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:communityapp/services/chat_service.dart';
import 'package:mime/mime.dart';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  final String channelId;
  final String username;
  final String userId;
  late final ChatService _chatService;
  final types.User user;
  late final StreamSubscription<DatabaseEvent> _messagesSubscription;
  RxList<types.Message> messagesList = <types.Message>[].obs;

  ChatController({
    required this.channelId,
    required this.user,
    required this.username,
    required this.userId,
  }) {
    _chatService = ChatService(channelId: channelId);
  }

  @override
  void onInit() {
    super.onInit();
    _loadMessages();
    _setListeners();
  }

  void _loadMessages() async {
    try {
      final messages = await _chatService.loadMessages();
      messagesList.assignAll(messages);
    } catch (e) {
      Get.snackbar("Error", "Failed to load messages: $e");
    }
  }

  void _setListeners() {
    final messagesRef =
        FirebaseDatabase.instance.ref('channels/$channelId/messages');
    _messagesSubscription = messagesRef.onChildAdded.listen((event) {
      final message = event.snapshot.value;
      if (message is Map<Object?, Object?>) {
        try {
          types.Message messageObj = _chatService.convertToMessage(message);

          _addMessage(messageObj);
        } catch (e) {
          Get.defaultDialog(title: "Alert", middleText: e.toString());
        }
      } else {
        Get.defaultDialog(title: "Alert", middleText: "Not a map");
      }
    });
  }

  void _addMessage(types.Message message) async {
    try {
      var box = await Hive.openBox<HiveMessage>('chatBox_$channelId');
      if (!messagesList.any((msg) => msg.id == message.id)) {
        await box.add(HiveMessage.fromChatMessage(message));
        messagesList.insert(0, message);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to save message in Hive: $e");
    }
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _chatService.sendMessageToFirebase(textMessage, username);
  }

  void handleFileSelection() async {
    Get.back(); // Close the bottom sheet
    final result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      for (var filePicked in result.files) {
        if (filePicked.path != null) {
          final file = File(filePicked.path!);
          final tempMessage = types.FileMessage(
            author: user,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            mimeType: lookupMimeType(result.files.single.path!),
            name: filePicked.name,
            size: filePicked.size,
            uri: filePicked.path!,
            showStatus: true,
            isLoading: true,
          );
          messagesList.insert(0, tempMessage);
          final uri =
              await _chatService.uploadFile(file, filePicked.name, channelId);
          messagesList.removeAt(0);
          if (uri.toString() != 'https://example.com') {
            final fileMessage = tempMessage.copyWith(
                uri: uri.toString(), isLoading: false, showStatus: false);
            _chatService.sendMessageToFirebase(fileMessage, username);
          } else {
            Get.snackbar("Error", "Failed to upload file ${filePicked.name}");
          }
        }
      }
    }
  }

  void handleImageSelection() async {
    Get.back();
    final List<XFile> result =
        await ImagePicker().pickMultiImage(); // Enable multiple image selection
    if (result.isNotEmpty) {
      for (var imagePicked in result) {
        final file = File(imagePicked.path);
        final tempMessage = types.ImageMessage(
          author: user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          name: imagePicked.name,
          size: await file.length(),
          uri: imagePicked.path,
          width: 1440,
          height: 1080,
        );
        messagesList.insert(0, tempMessage);

        try {
          final uri =
              await _chatService.uploadFile(file, imagePicked.name, channelId);
          messagesList.removeAt(0);
          if (uri.toString() != 'https://example.com') {
            final imageMessage = tempMessage.copyWith(
              uri: uri.toString(),
            );
            _chatService.sendMessageToFirebase(imageMessage, username);
          } else {
            Get.snackbar("Error", "Failed to upload image ${imagePicked.name}");
          }
        } catch (e) {
          Get.snackbar("Error", "Failed to upload image: $e");
        }
      }
    }
  }

  void handleMessageTap(BuildContext context, types.Message message) async {
    // if (message is types.FileMessage) {
    //   var localPath = message.uri;

    //   if (localPath.startsWith('http')) {
    //     try {
    //       // Find the message index in the list
    //       final index =
    //           messagesList.indexWhere((element) => element.id == message.id);

    //       // Update the message to show loading status
    //       final updatedMessage =
    //           (messagesList[index] as types.FileMessage).copyWith(
    //         isLoading: true,
    //       );
    //       messagesList[index] = updatedMessage;

    //       // Update in Hive
    //       await _chatService.updateMessageInHive(updatedMessage);

    //       // Download the file
    //       final client = http.Client();
    //       final request = await client.get(Uri.parse(message.uri));
    //       final bytes = request.bodyBytes;

    //       // Get the external storage directory
    //       final externalDir = await getExternalStorageDirectory();
    //       if (externalDir == null) {
    //         Get.snackbar("Error", "External storage directory not found");
    //         return;
    //       }
    //       final directoryPath = externalDir.path;

    //       // Create the directory if it doesn't exist
    //       final directory = Directory(directoryPath);
    //       if (!await directory.exists()) {
    //         await directory.create(recursive: true);
    //       }

    //       // Sanitize file name
    //       String sanitizedFileName =
    //           message.name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
    //       localPath = '$directoryPath/$sanitizedFileName';

    //       if (!await File(localPath).exists()) {
    //         // Save the file only if it doesn't exist
    //         final file = File(localPath);
    //         await file.writeAsBytes(bytes);
    //       }
    //     } catch (e) {
    //       Logging.log.e("Error downloading file: $e");
    //     } finally {
    //       final index =
    //           messagesList.indexWhere((element) => element.id == message.id);
    //       final updatedMessage = (messagesList[index] as types.FileMessage)
    //           .copyWith(isLoading: null, uri: localPath);

    //       messagesList[index] = updatedMessage;

    //       // Update in Hive
    //       await _chatService.updateMessageInHive(updatedMessage);
    //     }
    //   }
    //   if (await File(localPath).exists()) {
    //     await OpenFilex.open(localPath);
    //   } else {
    //     Logging.log.e("File does not exist at path: $localPath");
    //   }
    // }
  }

  void handlePreviewDataFetched(
    types.Message message,
    types.PreviewData previewData,
  ) {
    final index =
        messagesList.indexWhere((element) => element.id == message.id);
    if (index != -1) {
      final updatedMessage = (messagesList[index] as types.TextMessage)
          .copyWith(previewData: previewData);
      messagesList[index] = updatedMessage; // Update the observable list
    }
  }

  @override
  void onClose() {
    _messagesSubscription.cancel(); // Cancel the subscription
    super.onClose();
  }
}
