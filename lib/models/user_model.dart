import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
part 'user_model.g.dart';

@HiveType(typeId: 1)
class HiveUser {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String firstname;
  @HiveField(2)
  final String imageUrl;
  
  HiveUser({
    required this.id,
    required this.firstname,
    required this.imageUrl,
  });

    String get getId => id;
    String get getFirstname => firstname;
    String get getImageUrl => imageUrl;

  types.User toChatUser() {
    return types.User(
      id: id,
      imageUrl: imageUrl,
      firstName: firstname,
    );
  }

  factory HiveUser.fromChatUser(types.User user) {
    return HiveUser(
      id: user.id,
      firstname: user.firstName ?? "anonymous",
      imageUrl: user.imageUrl ?? "https://res.cloudinary.com/daj7vxuyb/image/upload/v1731866387/samples/balloons.jpg" ,
    );
  }
}