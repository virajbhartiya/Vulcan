import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../models/message.dart';

class DatabaseSQL {
  Database database;
  String username;
  DatabaseSQL(username) {
    this.username = username;
    init(this.username);
  }

  init(username) async {
    await openDatabase(join(await getDatabasesPath(), username + '.db'),
            onCreate: (db, version) async {
      return await db.execute("CREATE TABLE " +
          username +
          "(message TEXT, time INTEGER, sender TEXT, username TEXT, mediaType TEXT, mediaUrl TEXT)");
    }, version: 1)
        .then((db) {
      database = db;
    });
  }

  Future<void> insertMessage(Message message) async {
    if (database != null)
      await database.insert(
        message.username,
        message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }

  Future<List<Message>> getMessages(String username) async {
    final List<Map<String, dynamic>> maps = await database.query(username);
    return List.generate(maps.length, (i) {
      return Message(
        message: maps[i]['message'],
        sender: maps[i]['sender'],
        time: maps[i]['time'],
        mediaType: maps[i]['mediaType'],
        mediaUrl: maps[i]['mediaUrl'],
        username: username,
      );
    });
  }

  Future<void> deleteMessages(int time, String username) async {
    await database.delete(
      username,
      where: 'time = ?',
      whereArgs: [time],
    );
  }

  Future<Message> getLastMessage(String username) async {
    final List<Map<String, dynamic>> maps = await database.query(username);
    return Message(
      time: maps[maps.length - 1]['time'],
      message: maps[maps.length - 1]['message'],
      sender: maps[maps.length - 1]['sender'],
      username: maps[maps.length - 1]['username'],
      mediaType: maps[maps.length - 1]['mediaType'],
      mediaUrl: maps[maps.length - 1]['mediaUrl'],
    );
  }
}
