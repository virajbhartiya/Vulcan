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

  Message copyWith({
    String sender,
    String username,
    String message,
    int time,
    String mediaType,
    String mediaUrl,
  }) {
    return Message(
      sender: sender ?? this.sender,
      username: username ?? this.username,
      message: message ?? this.message,
      time: time ?? this.time,
      mediaType: mediaType ?? this.mediaType,
      mediaUrl: mediaUrl ?? this.mediaUrl,
    );
  }

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.sender == sender &&
        other.username == username &&
        other.message == message &&
        other.time == time &&
        other.mediaType == mediaType &&
        other.mediaUrl == mediaUrl;
  }

  @override
  int get hashCode {
    return sender.hashCode ^
        username.hashCode ^
        message.hashCode ^
        time.hashCode ^
        mediaType.hashCode ^
        mediaUrl.hashCode;
  }
}
