import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:riverpod_example/model/user.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static late Database _database;

  String usersTable = 'users';
  String columnage = 'age';
  String columnName = 'name';

  Future<Database> get database async {
    //if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'user.db';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // user
  // age | Name
  // 0    ..
  // 1    ..

  void _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $usersTable($columnage INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT)',
    );
  }

  // READ
  Future<List<User>> getusers() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> usersMapList =
    await db.query(usersTable);
    final List<User> usersList = [];
    usersMapList.forEach((userMap) {
      usersList.add(User.fromMap(userMap));
    });

    return usersList;
  }

  // INSERT
  Future<User> insertuser(User user) async {
    Database db = await this.database;
    user.age = await db.insert(usersTable, user.toMap());
    return user;
  }

  // UPDATE
  Future<int> updateuser(User user) async {
    Database db = await this.database;
    return await db.update(
      usersTable,
      user.toMap(),
      where: '$columnage = ?',
      whereArgs: [user.age],
    );
  }

  // DELETE
  Future<int> deleteuser(int? age) async {
    Database db = await this.database;
    return await db.delete(
      usersTable,
      where: '$columnage = ?',
      whereArgs: [age],
    );
  }
}