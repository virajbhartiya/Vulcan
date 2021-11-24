import 'dart:convert';

class Message {
  String sender;
  String username;
  String message;
  int time;
  String mediaType;
  String mediaUrl;
  Message({
    this.sender,
    this.username,
    this.message,
    this.time,
    this.mediaType,
    this.mediaUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'username': username,
      'message': message,
      'time': time,
      'mediaType': mediaType,
      'mediaUrl': mediaUrl,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      sender: map['sender'],
      username: map['username'],
      message: map['message'],
      time: map['time'],
      mediaType: map['mediaType'],
      mediaUrl: map['mediaUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(sender: $sender, username: $username, message: $message, time: $time, mediaType: $mediaType, mediaUrl: $mediaUrl)';
  }
}
