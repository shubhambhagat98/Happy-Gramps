import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_background/notebook_new/models/note.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper; //singleton DatabaseHelper
  static Database _database; //Singleton database

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();//Named constructor to create instance of DatabasHelper

  factory DatabaseHelper(){
    
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); //this is executed only once, Singleton object
    }

    return _databaseHelper;
  }

  Future<Database> get database async{
    
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async{
    //get the directory path for both android and ios to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notebook_module.db';

    //open-create database at a given path
    var noteDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return noteDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  //select statement
  Future<List<Map<String, dynamic>>> getNoteMapList() async{
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  //insert statement
  Future<int> insertNote(Note note) async{
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  //update statement
  Future<int> updateNote(Note note) async{
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  //delete statement
  Future<int> deleteNote(int id) async{
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  //get number of objects in database
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //get map list [List<Map>] and convert it to note list [List<Note>]
  Future<List<Note>> getNoteList()async{
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = List<Note>();
    //for loop to create a note list from map list
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

}