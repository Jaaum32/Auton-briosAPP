import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:autonebriosapp/models/caixa.dart';

class DatabaseHelperCaixa {
  static late DatabaseHelperCaixa _databaseHelperCaixa;
  static late Database _database;

  String caixaTable = 'caixa';
  String colId = 'id';
  String colInicioCriacao = 'inicioCriacao';
  String colFinalCriacao = 'finalCriacao';
  String colTemperatura = 'temperatura';
  String colUmidade = 'umidade';
  String colDieta = 'dieta';
  String colFuncao = 'funcao';

  DatabaseHelperCaixa._createInstance();

  factory DatabaseHelperCaixa() {
    _databaseHelperCaixa = DatabaseHelperCaixa._createInstance();

    return _databaseHelperCaixa;
  }

  Future<Database> get database async {
    _database = await initializeDatabase();

    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'atnebrios.db';

    var caixasDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return caixasDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $caixaTable($colId INTEGER PRIMARY KEY, $colInicioCriacao DATE, $colFinalCriacao DATE, $colTemperatura DECIMAL, $colUmidade DECIMAL, $colDieta INT, $colFuncao TEXT)');
  }

  void deleteDB() async {
    Database db = await this.database;
    db.execute("DROP TABLE $caixaTable");
  }

  void rebuildDB() async {
    Database db = await this.database;
    db.execute(
        'CREATE TABLE IF NOT EXISTS $caixaTable($colId INTEGER PRIMARY KEY, $colInicioCriacao TEXT, $colFinalCriacao TEXT, $colTemperatura DECIMAL, $colUmidade DECIMAL, $colDieta INT, $colFuncao TEXT)');
  }

  Future<int> insertCaixa(Caixa caixa) async {
    Database db = await this.database;

    var resultado = await db.insert(caixaTable, caixa.toMap());

    return resultado;
  }

  Future<Caixa?> getCaixa(int id) async{
    Database db = await this.database;;
    List<Map<String, dynamic>> maps = await db.query(caixaTable,
      columns: [colId, colInicioCriacao, colFinalCriacao, colTemperatura, colUmidade, colDieta, colFuncao],
      where: "$colId = ?",
      whereArgs: [id],
    );

    if(maps.length > 0){
      return Caixa.fromMap(maps[0]);
    }else{
      return null;
    }
  }

  Future<List<Caixa>> getCaixas() async {
    Database db = await this.database;

    var resultado = await db.query(caixaTable);

    List<Caixa> lista = resultado.isNotEmpty
        ? resultado.map((c) => Caixa.fromMap(c)).toList()
        : [];

    return lista;
  }

  Future<int> updateCaixa(Caixa caixa) async {
    var db = await this.database;

    var resultado = await db.update(caixaTable, caixa.toMap(),
        where: '$colId = ?', whereArgs: [caixa.id]);

    return resultado;
  }

  Future<int> deleteCaixa(int id) async {
    var db = await this.database;

    int resultado =
        await db.delete(caixaTable, where: "$colId = ?", whereArgs: [id]);

    return resultado;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $caixaTable');

    int? resultado = Sqflite.firstIntValue(x);
    return resultado!;
  }

  Future close() async {
    Database db = await this.database;
    db.close();
  }
}
