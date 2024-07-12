class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final int timestamp;

  Message(
      {required this.senderId,
      required this.receiverId,
      required this.message,
      required this.timestamp});

  factory Message.fromMap(Map<dynamic, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
