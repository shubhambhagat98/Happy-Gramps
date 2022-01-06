//import 'dart:convert';

//Medicine medicineFromJson(String str) => Medicine.fromMap(json.decode(str));
//String medicineToJson(Medicine data) => json.encode(data.toMap());

class Medicine{

  int _id;
  String _name;
  String _dosage;
  String _medicineType;
  int _interval;
  String _startTime;


  Medicine(this._name,  this._interval, this._startTime,  [this._dosage, this._medicineType,]);
  Medicine.withId(this._id, this._name,  this._interval, this._startTime,  [this._dosage, this._medicineType,]);

  int get id => _id;
  String get name => _name;
  String get dosage => _dosage;
  String get medicineType => _medicineType;
  int get interval => _interval;
  String get startTime => _startTime;
  

  set name(String newName){
    if (newName.length <= 255) {
      this._name = newName;
    }
  }

  set dosage(String newDosage){
    if (newDosage.length <= 255) {
      this._dosage = newDosage;
    }
  }

  set medicineType(String newMedicineType){
    if (newMedicineType.length <= 255) {
      this._medicineType = newMedicineType;      
    }
  }

  set interval(int newInterval){
    if (newInterval >= 6 && newInterval <=24) {
      this._interval = newInterval;
    }
  }

  set startTime(String newStartTime){
    if (newStartTime.length <= 255) {
      this._startTime = newStartTime;
    }
  }

  
  

   Map<String, dynamic> toMap(){

     var map = Map<String, dynamic>();
    if ( id != null) {
        map['id'] = _id;
      }
    map['name'] = _name;
    map['dosage'] = _dosage;
    map['medicineType'] = _medicineType;
    map['interval'] = _interval;
    map['startTime'] = _startTime;
    
 
    return map;
   }



  //extract medicine object from map object
 Medicine.fromMap(Map<String, dynamic> map){
    this._id = map['id'];
    this._name = map['name'];
    this._dosage = map['dosage'];
    this._medicineType = map['medicineType'];
    this._interval = map['interval'];
    this._startTime = map['startTime'];
    
    
  }



}




