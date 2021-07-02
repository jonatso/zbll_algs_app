import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'case.dart';
import 'alg.dart';
import 'algset.dart';

class DBHelper {
  static Database _db;
  static String dbName = "algs.sqlite";

  static Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  static initDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbName);
    var exists = await databaseExists(path);
    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await io.Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join('assets', dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await io.File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    return await openDatabase(path);
  }

  static Future<List<Algset>> getAlgsets() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM algsets");
    List<Algset> algsets = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        algsets.add(Algset.fromMap(maps[i]));
      }
    }
    return algsets;
  }

  static Future<List<Case>> getCases(int algsetId) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM cases WHERE algset_id=?",
        [algsetId.toString()]); //WHERE doesnt work...
    List<Case> cases = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        cases.add(Case.fromMap(maps[i]));
      }
    }
    return cases;
  }

  Future<List<Alg>> getAlgs(Case case2) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM algs WHERE case_id=? ORDER BY in_use DESC",
        [case2.case_id.toString()]);
    List<Alg> algs = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        algs.add(Alg.fromMap(maps[i]));
      }
    }
    return algs;
  }

  static Future<Alg> getMainAlg(Case case2) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM algs WHERE case_id=? ORDER BY in_use DESC LIMIT 1", //we're only getting one alg here :D
        [case2.case_id.toString()]);
    return maps.length > 0
        ? Alg.fromMap(maps[0])
        : Alg(0, case2.case_id, "No algs bro", "never",
            0); //making alg from first and only element :)
  }

  static void setMainAlg(Alg alg) async {
    var dbClient = await db;
    await dbClient.rawUpdate(
        "UPDATE algs SET in_use='1' WHERE alg_id=?", [alg.alg_id.toString()]);

    await dbClient.rawUpdate(
        "UPDATE algs SET in_use='0' WHERE alg_id!=?", [alg.alg_id.toString()]);
  }

  static void addAlg(Case case2, String alg) async {
    var dbClient = await db;
    await dbClient.rawInsert(
        "INSERT INTO algs (case_id, alg, time_added) VALUES (${case2.case_id}, '$alg', '${DateTime.now()}')");
    print("added alg to database");
  }
}
