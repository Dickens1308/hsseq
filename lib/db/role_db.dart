import 'dart:developer';
import 'dart:io';
import 'package:hsseq/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class RoleDatabase {
  static const _databaseName = 'RoleDB.db';
  static const _databaseVersion = 1;

  //Singleton Class(initiliaze only Once)
  RoleDatabase._();
  static final RoleDatabase instance = RoleDatabase._();

  Database? _database;

  Future<Database?> get database async {
    // ignore: unnecessary_null_comparison
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
     CREATE TABLE ${Roles.tableName}(
        ${Roles.colId} TEXT PRIMARY KEY, 
        ${Roles.colName} TEXT,
        ${Roles.colCreate} TEXT, 
        ${Roles.colUpdate} TEXT, 
        ${Roles.colGuard} TEXT
        )    
      ''').then((value) {
      log('Table Created');
    });
  }

  //inserting data to the database
  Future<int> insertData(Roles roles) async {
    Database? db = await database;

    return await db!
        .insert(Roles.tableName, roles.toMap(),
            conflictAlgorithm: ConflictAlgorithm.ignore)
        .catchError((onError) {});
  }

  //Retrieve Data from the Database
  Future<List<Roles>> fetchTransactions() async {
    Database? db = await database;

    var roles = await db!
        .query(
      Roles.tableName,
      columns: [
        Roles.colId,
        Roles.colName,
        Roles.colGuard,
        Roles.colUpdate,
        Roles.colCreate,
      ],
      limit: 15,
    )
        .catchError((onError) {
      throw Exception(onError.toString());
    });

    List<Roles> list = [];

    if (roles.isNotEmpty) {
      for (int i = 0; i < roles.length; i++) {
        list.add(Roles.fromMap(roles[i]));
      }
    }
    return list;
  }

  Future<int> deleteDb() async {
    Database? db = await database;

    return await db!.delete(Roles.tableName);
  }
}
