import 'package:hive/hive.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
part 'message_model.g.dart';

@HiveType(typeId: 0) // Assign a unique typeId for each model
class HiveMessage {
  @HiveField(0)
  String id;

  @HiveField(1)
  String authorId;

  @HiveField(2)
  String? authorName;

  @HiveField(3)
  int? createdAt;

  @HiveField(4)
  String type;

  @HiveField(5)
  String? text;

  @HiveField(6)
  String? uri;

  @HiveField(7)
  String? mimeType;

  @HiveField(8)
  int? size;

  @HiveField(9)
  double? height;

  @HiveField(10)
  double? width;

  @HiveField(11)
  String? name;

  HiveMessage({
    required this.id,
    required this.authorId,
    this.authorName,
    this.createdAt,
    required this.type,
    this.text,
    this.uri,
    this.mimeType,
    this.size,
    this.height,
    this.width,
    this.name,
  });

  /// Converts HiveMessage to `types.Message`
  types.Message toChatMessage() {
    final author = types.User(id: authorId, firstName: authorName);

    switch (type) {
      case 'text':
        return types.TextMessage(
          id: id,
          author: author,
          createdAt: createdAt,
          text: text!,
        );
      case 'image':
        return types.ImageMessage(
          id: id,
          author: author,
          createdAt: createdAt,
          uri: uri!,
          height: height,
          width: width,
          name: name ?? 'unknown',
          size: size?? 1000,
        );
      case 'file':
        return types.FileMessage(
          id: id,
          author: author,
          createdAt: createdAt,
          uri: uri!,
          mimeType: mimeType,
          name: name ?? 'unknown',
          size: size ?? 1000,
        );
      default:
        throw UnsupportedError('Unsupported message type: $type');
    }
  }

  /// Converts `types.Message` to HiveMessage
  factory HiveMessage.fromChatMessage(types.Message message) {
    final author = message.author;

    if (message is types.TextMessage) {
      return HiveMessage(
        id: message.id,
        authorId: author.id,
        authorName: author.firstName,
        createdAt: message.createdAt,
        type: 'text',
        text: message.text,
      );
    } else if (message is types.ImageMessage) {
      return HiveMessage(
        id: message.id,
        authorId: author.id,
        authorName: author.firstName,
        createdAt: message.createdAt,
        type: 'image',
        uri: message.uri,
        height: message.height,
        width: message.width,
        name: message.name,
        size: message.size as int?,
      );
    } else if (message is types.FileMessage) {
      return HiveMessage(
        id: message.id,
        authorId: author.id,
        authorName: author.firstName,
        createdAt: message.createdAt,
        type: 'file',
        uri: message.uri,
        mimeType: message.mimeType,
        name: message.name,
        size: message.size as int?,
      );
    } else {
      throw UnsupportedError('Unsupported message type: ${message.runtimeType}');
    }
  }

}
