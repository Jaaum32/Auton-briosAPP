import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:autonebriosapp/models/dieta.dart';

class DatabaseHelperDieta {
  static late DatabaseHelperDieta _databaseHelperDieta;
  static late Database _database;

  String dietaTable = 'dieta';
  String colId = 'id';
  String colAlimento1 = 'alimento1';
  String colQuantidade1 = 'quantidade1';
  String colAlimento2 = 'alimento2';
  String colQuantidade2 = 'quantidade2';
  String colAlimento3 = 'alimento3';
  String colQuantidade3 = 'quantidade3';
  String colTempoDeTroca = 'tempoDeTroca';
  String colTempoTotal = 'tempoTotal';
  String colDescricao = 'descricao';

  DatabaseHelperDieta._createInstance();

  factory DatabaseHelperDieta() {
    _databaseHelperDieta = DatabaseHelperDieta._createInstance();

    return _databaseHelperDieta;
  }

  Future<Database> get database async {
    _database = await initializeDatabase();

    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "atnebrios.db";

    var dietasDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return dietasDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $dietaTable($colId INTEGER PRIMARY KEY, $colAlimento1 TEXT, $colQuantidade1 DECIMAL,  $colAlimento2 TEXT, $colQuantidade2 DECIMAL, $colAlimento3 TEXT, $colQuantidade3 DECIMAL, $colTempoDeTroca INT, $colTempoTotal INT, $colDescricao TEXT)');
  }

  void deleteDB() async {
    Database db = await this.database;
    db.execute("DROP TABLE $dietaTable");
  }

  void rebuildDB() async {
    Database db = await this.database;
    db.execute(
        'CREATE TABLE IF NOT EXISTS $dietaTable($colId INTEGER PRIMARY KEY, $colAlimento1 TEXT, $colQuantidade1 DECIMAL,  $colAlimento2 TEXT, $colQuantidade2 DECIMAL, $colAlimento3 TEXT, $colQuantidade3 DECIMAL, $colTempoDeTroca INT, $colTempoTotal INT, $colDescricao TEXT)');
  }

  Future<int> insertDieta(Dieta dieta) async {
    Database db = await this.database;

    var resultado = await db.insert(dietaTable, dieta.toMap());

    return resultado;
  }

  Future<Dieta> getDieta(int id) async {
    Database db = await this.database;

    var resultado =
    await db.rawQuery('SELECT * FROM $dietaTable WHERE $colId = ?', ['$id']);

    List<Dieta> lista = resultado.isNotEmpty
        ? resultado.map((c) => Dieta.fromMap(c)).toList()
        : [];

    //print(lista[0]);
    return lista[0];
  }

  Future<List<Dieta>> getDietas() async {
    Database db = await this.database;

    var resultado = await db.query(dietaTable);

    List<Dieta> lista = resultado.isNotEmpty
        ? resultado.map((c) => Dieta.fromMap(c)).toList()
        : [];

    return lista;
  }

  Future<int> updateDieta(Dieta dieta) async {
    var db = await this.database;

    var resultado = await db.update(dietaTable, dieta.toMap(),
        where: '$colId = ?', whereArgs: [dieta.id]);

    return resultado;
  }

  Future<int> deleteDieta(int id) async {
    var db = await this.database;

    int resultado =
        await db.delete(dietaTable, where: "$colId = ?", whereArgs: [id]);

    return resultado;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $dietaTable');

    int? resultado = Sqflite.firstIntValue(x);
    return resultado!;
  }

  Future close() async {
    Database db = await this.database;
    db.close();
  }
}
