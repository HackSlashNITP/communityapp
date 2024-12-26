class Group {
  String? avatar;
  String? name;
  String? id;
  String? creationDate;
  String? description;
  int? unreads = 0;
  LastMessage? lastmessage;

  Group(
      {this.avatar,
      this.name,
      this.id,
      this.creationDate,
      this.description,
      this.lastmessage,
      this.unreads});

  factory Group.fromJson(Map<dynamic, dynamic> json, int num, String id) {
    return Group(
      id: id,
      avatar: json['avatar'] as String?,
      name: json['name'] as String?,
      creationDate: json['creation_date'] as String?,
      description: json['description'] as String?,
      unreads: num.toInt(),
      lastmessage: json['lastmessage'] != null
          ? LastMessage.fromJson(json['lastmessage'])
          : LastMessage(sender: 'Remainder ', message: 'All the group members are requested to follow community guidelines'),
    );
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['avatar'] = avatar;
    data['name'] = name;
    data['creation_date'] = creationDate;
    data['description'] = description;
    if (lastmessage != null) {
      data['lastmessage'] = lastmessage!.toJson();
    }
    return data;
  }
}

class LastMessage {
  String? sender;
  String? message;

  LastMessage({this.sender, this.message});

  factory LastMessage.fromJson(dynamic rawData) {
    if (rawData is Map) {
      return LastMessage(
        sender: rawData['sender'] as String?,
        message: rawData['message'] as String?,
      );
    } else {
      throw Exception('Invalid rawData type');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender'] = sender;
    data['message'] = message;
    return data;
  }
}
