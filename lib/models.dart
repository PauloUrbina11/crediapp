import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  int? id;
  String name;
  String email;
  int identification;
  String password;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.identification,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'identification': identification,
      'password': password,
    };
  }
}

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final databasesPath = join(documentsDirectory.path, 'database');
      await Directory(databasesPath).create(recursive: true);
      final path = join(databasesPath, 'crediappdb.db');

      return openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          print('Creating users table...');
          await db.execute('''
            CREATE TABLE users(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              identification INTEGER,
              email TEXT,
              password TEXT
            )
          ''');
        },
      );
    } catch (e) {
      print('Error opening database: $e');
      rethrow;
    }
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    print('Inserting user: ${user.toMap()}');
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User?>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        email: maps[i]['email'],
        identification: maps[i]['identification'],
        password: maps[i]['password'],
      );
    });
  }

  Future<int?> getUserIdByUserName(String userName) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [userName],
    );

    if (result.isNotEmpty) {
      return result[0]['id'] as int;
    } else {
      return null;
    }
  }
}
