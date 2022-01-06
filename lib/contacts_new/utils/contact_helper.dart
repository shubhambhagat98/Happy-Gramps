import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_background/contacts_new/models/contact.dart';

class ContactHelper {

  static ContactHelper _contactHelper; //singleton databasehelper
  static Database _database;

  String contactTable = 'contact_table';
  String colId = 'id';
  String colName = 'name';
  String colPhone = 'phone';
  String colEmail = 'email';
  String colImage = 'image';
  String colCategory = 'category';

  ContactHelper._createInstance(); //Named constructor to create instance of DatabasHelper

  factory ContactHelper(){

    if (_contactHelper == null) {
      _contactHelper = ContactHelper._createInstance();
    }

    return _contactHelper;
  }

  Future<Database> get database async{
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;

  }

  Future<Database> initializeDatabase()async{
     //get the directory path for both android and ios to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'contact_module.db';

    //open-create database at a given path
    var contactDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return contactDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $contactTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colPhone TEXT, $colEmail TEXT, $colImage TEXT, $colCategory INTEGER)');
  }

  //select statement
  Future<List<Map<String, dynamic>>> getContactMapList() async{
    Database db = await this.database;

    var result = await db.query(contactTable, orderBy: '$colName ASC');
    return result;
  }


  //get map list [List<Map>] and convert it to note list [List<contact>]
  Future<List<Contact>> getContactList()async{
    var contactMapList = await getContactMapList();
    int count = contactMapList.length;

    List<Contact> contactList = List<Contact>();
    //for loop to create a contact list from map list
    for (int i = 0; i < count; i++) {
      contactList.add(Contact.fromMapObject(contactMapList[i]));
    }

    return contactList;
  }

  //alert contact - select statement
  Future<List<Map<String, dynamic>>> getAlertContactMapList()async{
    Database db = await this.database;

    var result = db.rawQuery('SELECT * FROM $contactTable WHERE $colCategory == 1 or $colCategory == 2');
    return result;

  }

  //alert contact- list
  Future<List<Contact>> getAlertContactList() async{
    var alertcontactmaplist = await getAlertContactMapList();
    int count = alertcontactmaplist.length;
    List<Contact> alertcontactlist = List<Contact> ();
    for (var i = 0; i < count; i++) {
      alertcontactlist.add(Contact.fromMapObject(alertcontactmaplist[i]));
    }

    return alertcontactlist;

  }

   //insert statement
  Future<int> insertContact(Contact contact) async{
    Database db = await this.database;
    var result = await db.insert(contactTable, contact.toMap());
    return result;
  }

  //update statement
  Future<int> updateContact(Contact contact) async{
    Database db = await this.database;
    var result = await db.update(contactTable, contact.toMap(), where: '$colId = ?', whereArgs: [contact.id]);
    return result;
  }

  //delete statement
  Future<int> deleteContact(int id) async{
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $contactTable WHERE $colId = $id');
    return result;
  }

  //get number of objects in database
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $contactTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}