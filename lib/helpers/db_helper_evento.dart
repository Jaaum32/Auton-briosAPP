import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:autonebriosapp/models/evento.dart';

class DatabaseHelperEvento {
  static late DatabaseHelperEvento _databaseHelperEvento;
  static late Database _database;

  String eventoTable = 'evento';
  String colId = 'id';
  String colIdCaixa = 'idCaixa';
  String colUrgencia = 'urgencia';
  String colData = 'data';
  String colDescricao = 'descricao';

  DatabaseHelperEvento._createInstance();

  factory DatabaseHelperEvento() {
    _databaseHelperEvento = DatabaseHelperEvento._createInstance();

    return _databaseHelperEvento;
  }

  Future<Database> get database async {
    _database = await initializeDatabase();

    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "atnebrios.db";

    var eventosDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return eventosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $eventoTable($colId INTEGER PRIMARY KEY, $colIdCaixa INT, $colUrgencia TEXT, $colData TEXT, $colDescricao TEXT)');
  }

  void deleteDB() async {
    Database db = await this.database;
    db.execute("DROP TABLE $eventoTable");
  }

  void rebuildDB() async {
    Database db = await this.database;
    db.execute(
        'CREATE TABLE IF NOT EXISTS $eventoTable($colId INTEGER PRIMARY KEY, $colIdCaixa INT, $colUrgencia TEXT, $colData TEXT, $colDescricao TEXT)');
  }

  Future<int> insertEvento(Evento evento) async {
    Database db = await this.database;

    var resultado = await db.insert(eventoTable, evento.toMap());

    return resultado;
  }


  Future<List<Evento>> getEventos() async {
    Database db = await this.database;

    var resultado = await db.query(eventoTable);

    List<Evento> lista = resultado.isNotEmpty
        ? resultado.map((c) => Evento.fromMap(c)).toList()
        : [];

    return lista;
  }

  Future<int> updateEvento(Evento evento) async {
    var db = await this.database;

    var resultado = await db.update(eventoTable, evento.toMap(),
        where: '$colId = ?', whereArgs: [evento.id]);

    return resultado;
  }

  Future<int> deleteEvento(int id) async {
    var db = await this.database;

    int resultado =
    await db.delete(eventoTable, where: "$colId = ?", whereArgs: [id]);

    return resultado;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $eventoTable');

    int? resultado = Sqflite.firstIntValue(x);
    return resultado!;
  }

  Future close() async {
    Database db = await this.database;
    db.close();
  }
}
