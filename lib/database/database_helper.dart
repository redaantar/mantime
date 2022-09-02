import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:mantime/models/task_model.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _tasksTableName = "tasks";
  static const String _completedTasksTableName = "completedTasks";
  static const String _sqltasksTable = "CREATE TABLE $_tasksTableName("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "title STRING, description TEXT, date STRING, "
      "startTime STRING, endTime STRING, "
      "remind INTEGER, repeat STRING, "
      "color INTEGER, "
      "isCompleted INTEGER);";
  static const String _sqlCompTasks = "CREATE TABLE $_completedTasksTableName("
      "id INTEGER, "
      "isCompletedDate STRING);";

  static Future<Void?>? initializeDatabase() async {
    if (_database != null) {
      return null;
    }
    try {
      String path = '${await getDatabasesPath()}tasksDB.db';
      _database = await openDatabase(path, version: _version,
          onCreate: (db, version) async {
        await db.execute(_sqlCompTasks);
        await db.execute(_sqltasksTable);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<int> insert(TaskModel? task) async {
    return await _database?.insert(_tasksTableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _database!.query(_tasksTableName);
  }

  static Future<List<Map<String, Object?>>> completedQuery() async {
    return await _database!.rawQuery('SELECT * FROM $_completedTasksTableName');
  }

  static delete(TaskModel task) async {
    await _database!
        .delete(_tasksTableName, where: 'id=?', whereArgs: [task.id]);
    await _database!
        .delete(_completedTasksTableName, where: 'id=?', whereArgs: [task.id]);
  }

  static completeTask(int id, String selectedDate) async {
    await _database!.rawUpdate('''
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
      ''', [1, id]);
    await _database?.insert(
        _completedTasksTableName, {"id": id, "isCompletedDate": selectedDate});
  }
}
