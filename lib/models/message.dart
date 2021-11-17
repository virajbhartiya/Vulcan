import 'dart:convert';

class Message {
  String sender;
  String username;
  int id;
  String message;
  int time;
  Message({
    this.sender,
    this.username,
    this.id,
    this.message,
    this.time,
  });

  Message copyWith({
    String sender,
    String username,
    int id,
    String message,
    int time,
  }) {
    return Message(
      sender: sender ?? this.sender,
      username: username ?? this.username,
      id: id ?? this.id,
      message: message ?? this.message,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'time': time,
      'sender': sender,
      'username': username,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      sender: map['sender'],
      username: map['username'],
      id: map['id'],
      message: map['message'],
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(sender: $sender, username: $username, id: $id, message: $message, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.sender == sender &&
        other.username == username &&
        other.id == id &&
        other.message == message &&
        other.time == time;
  }

  @override
  int get hashCode {
    return sender.hashCode ^
        username.hashCode ^
        id.hashCode ^
        message.hashCode ^
        time.hashCode;
  }
}
