
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_background/medicine_app/model/medicine.dart';
import 'package:flutter_background/medicine_app/model/notification.dart';

class MedicineHelper{

  static MedicineHelper _medicineHelper;
  static Database _database;

  String medicineTable = 'medicine_table';
  String colId = 'id';
  String colName = 'name';
  String colDosage = 'dosage';
  String colMedicineType = 'medicineType';
  String colInterval = 'interval';
  String colStartTime = 'startTime';

  String notificationTable = 'notification_table';
  String colMedicineId = 'medicineId';
  String colNotificationId = 'notificationId';

  MedicineHelper._createInstance();

  factory MedicineHelper(){

    if (_medicineHelper == null) {
      _medicineHelper = MedicineHelper._createInstance();
    }
    return _medicineHelper;
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
    String path = directory.path + 'medicine_module.db';

    //open-create database at a given path
    var medicineDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return medicineDatabase;
  }


  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $medicineTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colDosage TEXT, $colMedicineType TEXT, $colInterval INTEGER, $colStartTime TEXT )');
    await db.execute('CREATE TABLE $notificationTable($colMedicineId INTEGER, $colNotificationId INTEGER)');
  }

  //select statement - MEDICINE TABLE
  Future<List<Map<String, dynamic>>> getMedicineMapList() async{
    Database db = await this.database;
    var result = await db.query(medicineTable, orderBy: '$colId ASC');
     //debugPrint(result.toString());
    return result;
  }

  //get maplist and convert to medicine list - MEDICINE TABLE
  Future<List<Medicine>> getMedicineList() async{
    var medicineMapList = await getMedicineMapList();
    int count = medicineMapList.length;

    List<Medicine> medicineList = List<Medicine>();
    //for loop to create a medicine list from map list
    for (int i = 0; i < count; i++) {
      medicineList.add(Medicine.fromMap(medicineMapList[i]));
     
    }
    return medicineList;
  }

  //SELECT NOTIFICATION TABLE
  Future<List<Map<String, dynamic>>> getNotificationMapList(int medicineId) async{
    Database db = await this.database;
    var result = db.rawQuery('SELECT * FROM $notificationTable where $colMedicineId = $medicineId');
    return result;
  }
  
  //NOTIFICATION TABLE - NOTIFICATION LIST
  Future<List<NotificationList>> getNotificationList(int medicineId) async{
    var notificationMapList = await getNotificationMapList(medicineId);
    int count = notificationMapList.length;
    List<NotificationList> notificationList = List<NotificationList>();
    for (int i = 0; i < count ; i++){
      notificationList.add(NotificationList.fromMap(notificationMapList[i]));
    }
    return notificationList;
  }


  //insert statement - MEDICINE TABLE
  Future<int> insertMedicine(Medicine medicine) async{
    Database db = await this.database;
    
    var result = await db.insert(medicineTable, medicine.toMap());
    return result;
  }

  //insert notification
  Future<int> insertNotification(int medicineId, int notificationId) async{
    Database db = await this.database;
    int medicineID = medicineId;
    int notificationID = notificationId;

    //var result = await db.insert(notificationTable, notification.toMap());
    var result = db.rawInsert('INSERT INTO $notificationTable($colMedicineId, $colNotificationId) VALUES(?, ?)', [medicineID, notificationID]);
    return result;
  }

  //update statement - MEDICINE TABLE
  Future<int> updateMedince(Medicine medicine) async{
    Database db = await this.database;
    var result = await db.update(medicineTable, medicine.toMap(), where: '$colId = ?', whereArgs: [medicine.id] );
    return result;
  }

  //delete statement - MEDICINE TABLE
  Future<int> deleteMedicine(int id) async{
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $medicineTable WHERE $colId = $id');
    return result;
  }

  //delete notification

  Future<int> deleteNotification(int id) async{
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $notificationTable WHERE $colMedicineId = $id');
    return result;

  }

  //get number of objects in the database 
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $medicineTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

}