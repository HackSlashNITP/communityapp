import 'dart:async';
import 'dart:io';
// ignore: implementation_imports (don't ignore this message) this must be changed in future when newer version of this package will be public
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:communityapp/models/group_model.dart';
import 'package:communityapp/models/message_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final String channelId;

  ChatService({required this.channelId});

  Future<types.User> initializeUser(String username, String userId) async {
    try {
      final event = await FirebaseDatabase.instance
          .ref('users/$username/avatarLink')
          .once();
      final avatarLink = event.snapshot.value as String?;
      return types.User(
        id: userId,
        firstName: username,
        imageUrl: avatarLink,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<types.Message>> loadMessages() async {
    try {
      var box = await Hive.openBox<HiveMessage>('chatBox_$channelId');
      return box.values
          .map((hiveMessage) => hiveMessage.toChatMessage())
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveMessageToHive(types.Message message) async {
    try {
      var box = await Hive.openBox<HiveMessage>('chatBox_$channelId');
      await box.add(HiveMessage.fromChatMessage(message));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessageToFirebase(
      types.Message message, String username) async {
    try {
      final messagesRef =
          FirebaseDatabase.instance.ref('channels/$channelId/messages');
      final newMessageRef = messagesRef.push();
      String newid = newMessageRef.key ?? const Uuid().v4();

      final messageJson = message.toJson()..['id'] = newid;
      final LastMessage lastMessage = LastMessage.fromJson({
        "sender": username,
        "message": message.type.toString() == "text"
            ? messageJson["text"]
            : messageJson['name'] ?? "Unknown Type"
      });
      await newMessageRef.set(messageJson);
      await FirebaseDatabase.instance
          .ref('channels/$channelId/ChannelInfo/lastmessage')
          .set(lastMessage.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<Uri> uploadFile(File file, String filename, String foldername) async {
    try {
      var cloudinary = Cloudinary.fromStringUrl(
          'cloudinary://239118281366527:${dotenv.env['CloudinaryApi']}@daj7vxuyb');
      cloudinary.config.urlConfig.secure = true;

      var response = await cloudinary.uploader().upload(
            file,
            params: UploadParams(
              folder: foldername,
              filename: filename,
              uniqueFilename: false,
              useFilename: true,
              overwrite: false,
              resourceType: 'auto',
            ),
          );

      if (response != null &&
          response.data != null &&
          response.data?.secureUrl != null) {
        return Uri.parse(response.data!.secureUrl!);
      }
      return Uri.parse('https://example.com');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMessageInHive(types.Message message) async {
    try {
      var box = await Hive.openBox<HiveMessage>('chatBox_$channelId');
      final hiveMessage = HiveMessage.fromChatMessage(message);
      await box.put(hiveMessage.id, hiveMessage);
    } catch (e) {
      rethrow;
    }
  }

  types.Message convertToMessage(Map<Object?, Object?> rawData) {
    // Cast the data to a usable format
    final data = Map<String, dynamic>.from(rawData);

    final authorData =
        Map<String, dynamic>.from(data['author'] as Map<Object?, Object?>);
    final author = types.User(
      id: authorData['id'] as String,
      firstName: authorData['firstName'] as String?,
    );

    final createdAt = data['createdAt'] as int?;

    switch (data['type']) {
      case 'text':
        return types.TextMessage(
          id: data['id'] as String,
          author: author,
          createdAt: createdAt,
          text: data['text'] as String,
        );

      case 'image':
        return types.ImageMessage(
          id: data['id'] as String,
          author: author,
          createdAt: createdAt,
          height: (data['height'] as num?)?.toDouble(),
          width: (data['width'] as num?)?.toDouble(),
          name: data['name'] as String? ?? 'Unnamed',
          size: data['size'] as int? ?? 10000,
          uri: data['uri'] as String,
        );

      case 'file':
        return types.FileMessage(
          id: data['id'] as String,
          author: author,
          createdAt: createdAt,
          name: data['name'] as String? ?? 'Unnamed',
          size: data['size'] as int? ?? 10000,
          mimeType: data['mimeType'] as String?,
          uri: data['uri'] as String,
        );

      default:
        throw UnsupportedError('Unsupported message type: ${data['type']}');
    }
  }
}
