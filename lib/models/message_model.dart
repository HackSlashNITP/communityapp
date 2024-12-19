
class Message {
  final String id;
  final String sender;
  final String message;
  final String time;
  final String fileType;

  Message({
    required this.id,
    required this.sender,
    required this.message,
    required this.time,
    required this.fileType,
  });


  factory Message.fromMap(Map<dynamic, dynamic> data, String id) {
    return Message(
      id: id,
      sender: data['sender'] ?? '',
      message: data['message'] ?? '',
      time: data['time'] ?? '',
      fileType: data['fileType'] ?? 'text',
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'message': message,
      'time': time,
      'fileType': fileType,
    };
  }
}
