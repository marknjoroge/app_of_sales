import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../utils/database.dart';

class DatabaseHelper {
  late Database? _database;

  Future<Database> get database async {
    print("database called");
    _database = await _initDatabase();
    if (_database != null) return _database!;
    print("database called 2");
    // If _database is not open, initialize it
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sales.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    // Create the Sales table
    await db.execute(
        'CREATE TABLE ${SalesTable.tableName} (${SalesTable.idCol} INTEGER PRIMARY KEY AUTOINCREMENT, ${SalesTable.nameCol} TEXT, ${SalesTable.quantityCol} INTEGER, ${SalesTable.dateCol} TEXT, ${SalesTable.timeCol} TEXT, ${SalesTable.priceCol} REAL, ${SalesTable.typeOfEntry} TEXT)');

    // Create the Prices table
    await db.execute(
        'CREATE TABLE ${PricesTable.tableName} (${PricesTable.idCol} INTEGER PRIMARY KEY AUTOINCREMENT, ${PricesTable.nameCol} TEXT, ${PricesTable.priceCol} REAL)');
  }

  Future<int> insertStuff(Map<String, dynamic> row, String table) async {
    Database db = await database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    Database db = await database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryDay(String table, String date) async {
    Database db = await database;
    print("queried day");
    return await db
        .query(table, where: '${SalesTable.dateCol} = ?', whereArgs: [date]);
  }

  Future<List<Map<String, dynamic>>> queryCustom(String table, String query, List<Object> whereArgs) async {
    Database db = await database;
    print("queried day");
    return await db
        .query(table, where: query, whereArgs: whereArgs);
  }

  Future<int> updateStuff(Map<String, dynamic> row, String table) async {
    Database db = await database;
    int id = row['id'];
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteStuff(int id, String table) async {
    Database db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
