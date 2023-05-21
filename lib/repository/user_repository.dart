import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:riverpod_example/model/user.dart';
import 'package:path_provider/path_provider.dart';

final userRepositoryProvider =
Provider<UserRepository>((ref) => UserRepository());

class UserRepository {
  static final _databaseName = "myDatabasa.db";
  static final _databaseVersion = 1;

  static final table = 'users';
  static final columnId = '_id';
  static final columnName = 'name';

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE $table ($columnId INTEGER PRIMARY KEY, $columnName TEXT NOT NULL )    ');
  }

  Future<int> addUser(User user) async {
    final db = await _initDatabase();
    return await db.insert(table, {
      columnName: user.name,
    });
  }

  Future<List<User>> getUsers() async {
    final db = await _initDatabase();
    List<Map<String, dynamic>> users = await db.query(table);
    return users.map((user) => User.fromMap(user)).toList();
  }

  Future<User?> getUserById(int id) async {
    final db = await _initDatabase();
    List<Map<String, dynamic>> users =
    await db.query(table, where: '$columnId = ?', whereArgs: [id]);
    if (users.isNotEmpty) {
      return User.fromMap(users.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await _initDatabase();
    return await db.update(table, {
      columnName: user.name,
    }, where: '$columnId = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    final db = await _initDatabase();
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
