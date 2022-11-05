import 'dart:developer';
import 'dart:io';
import 'package:hsseq/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class UserDatabase {
  static const _databaseName = 'UserDB.db';
  static const _databaseVersion = 1;

  //Singleton Class(initiliaze only Once)
  UserDatabase._();
  static final UserDatabase instance = UserDatabase._();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();

    return _database;
  }

  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, _databaseName);

    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDb);
  }

  _onCreateDb(Database db, int version) async {
    await db.execute('''
     CREATE TABLE ${User.tableName}(
        ${User.colId} TEXT PRIMARY KEY, 
        ${User.colName} TEXT,
        ${User.colEmail} TEXT,
        ${User.colCreate} TEXT, 
        ${User.colUpdate} TEXT, 
        ${User.colDepartmentId} TEXT,
        ${User.colPhone} TEXT
        )    
      ''').then((value) {
      log('Table Created');
    });
  }

  //inserting data to the database
  Future<int> insertData(User user) async {
    Database? db = await database;

    return await db!
        .insert(User.tableName, user.toMap(),
            conflictAlgorithm: ConflictAlgorithm.ignore)
        .catchError((onError) {});
  }

  //Retrieve Data from the Database
  Future<User> fetchTransactions() async {
    Database? db = await database;

    var users = await db!
        .query(
          User.tableName,
          columns: [
            User.colId,
            User.colName,
            User.colEmail,
            User.colDepartmentId,
            User.colPhone,
            User.colUpdate,
            User.colCreate,
          ],
          limit: 15,
        )
        .catchError((onError) {});

    List<User> list = [];

    if (users.isNotEmpty) {
      for (int i = 0; i < users.length; i++) {
        list.add(User.fromMap(users[i]));
      }
    }
    return list.first;
  }

  Future<int> deleteDb() async {
    Database? db = await database;

    return await db!.delete(User.tableName);
  }
}
