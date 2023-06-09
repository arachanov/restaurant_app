import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:riverpod_example/model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "myDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'users';
  static final columnId = '_id';
  static final columnName = 'name';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL
          )
          ''');
  }

  Future<int> addUser(User user) async {
    Database db = await instance.database;
    return await db.insert(table, {
      columnName: user.name,
    });
  }

  Future<List<User>> getUsers() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users = await db.query(table);
    return users.map((user) => User.fromMap(user)).toList();
  }

  Future<User?> getUserById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users =
    await db.query(table, where: '$columnId = ?', whereArgs: [id]);
    if (users.isNotEmpty) {
      return User.fromMap(users.first);
    }
    return null;
  }
  Future<int> updateUser(User user) async {
    Database db = await instance.database;
    return await db.update(table, {
      columnName: user.name,
    }, where: '$columnId = ?', whereArgs: [user.id]);
  }
  Future<int> deleteUser(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
