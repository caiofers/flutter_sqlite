import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool verbose = true;

  _getDatabase() async {
    final databasePath = await getDatabasesPath();
    final databaseLocal = join(databasePath, 'banco.db');

    var database =
        await openDatabase(databaseLocal, version: 1, onCreate: (db, version) {
      String sql =
          "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR, age INTEGER)";
      db.execute(sql);
    });

    if (kDebugMode) {
      print("Database open: ${database.isOpen}");
    }

    return database;
  }

  _saveUser(String name, int age) async {
    Database db = await _getDatabase();

    Map<String, dynamic> userData = {"name": name, "age": age};

    int id = await db.insert("users", userData);

    if (kDebugMode) {
      print("User saved. Id: $id");
    }

    return id;
  }

  _updateUser(int id, String name, int age) async {
    Database db = await _getDatabase();

    Map<String, dynamic> userData = {"name": name, "age": age};

    int updatedItensCount =
        await db.update("users", userData, where: "id = ?", whereArgs: [id]);

    if (kDebugMode) {
      print("Amount users updated: $updatedItensCount");
    }

    return updatedItensCount;
  }

  _deleteUserById(int id) async {
    Database db = await _getDatabase();
    int deletedItensCount =
        await db.delete("users", where: "id = ?", whereArgs: [id]);

    if (kDebugMode) {
      print("Amount users deleted: $deletedItensCount");
    }

    return deletedItensCount;
  }

  _deleteUserByNameAndAge(String name, int age) async {
    Database db = await _getDatabase();
    int deletedItensCount = await db
        .delete("users", where: "name = ? AND age = ?", whereArgs: [name, age]);

    if (kDebugMode) {
      print("Amount users deleted: $deletedItensCount");
    }

    return deletedItensCount;
  }

  _getUserById(int id) async {
    Database db = await _getDatabase();

    List users = await db.query("users",
        columns: ["id", "name", "age"], where: "id = ?", whereArgs: [id]);

    if (kDebugMode) {
      for (var user in users) {
        print("User id: ${user['id']}");
        print("User name: ${user['name']}");
        print("User age: ${user['age']}");
      }
    }

    return users;
  }

  _getAllUsers() async {
    Database db = await _getDatabase();

    List users = await db.query("users", columns: ["id", "name", "age"]);

    if (kDebugMode) {
      for (var user in users) {
        print("User id: ${user['id']}");
        print("User name: ${user['name']}");
        print("User age: ${user['age']}");
      }
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    //_saveUser("Carol Ferreira", 24);
    //_updateUser(1, "Teste Fernandes", 0);
    //_deleteUserById(1);
    //_getAllUsers();
    //_getUserById(2);
    return Container();
  }
}
