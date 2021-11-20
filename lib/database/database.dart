import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../models/message.dart';

class DatabaseSQL {
  static Database database;
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
          "(id INTEGER, message TEXT, time INTEGER, sender TEXT, username TEXT, mediaType TEXT, mediaUrl TEXT)");
    }, version: 1)
        .then((db) {
      database = db;
    });
  }

  Future<void> insertMessage(Message message) async {
    final db = database;
    await db.insert(
      message.username,
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Message>> getMessages(String username) async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query(username);
    return List.generate(maps.length, (i) {
      return Message(
        id: maps[i]['id'],
        message: maps[i]['message'],
        sender: maps[i]['sender'],
        time: maps[i]['time'],
        mediaType: maps[i]['mediaType'],
        mediaUrl: maps[i]['mediaUrl'],
        username: username,
      );
    });
  }

  Future<void> deleteMessages(int id, String username) async {
    final db = database;
    await db.delete(
      username,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Message> getLastMessage(String username) async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query(username);
    return Message(
      id: maps[maps.length - 1]['id'],
      time: maps[maps.length - 1]['time'],
      message: maps[maps.length - 1]['message'],
      sender: maps[maps.length - 1]['sender'],
      username: maps[maps.length - 1]['username'],
      mediaType: maps[maps.length - 1]['mediaType'],
      mediaUrl: maps[maps.length - 1]['mediaUrl'],
    );
  }
}
