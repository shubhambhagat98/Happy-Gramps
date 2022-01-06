class NotificationList{

  int _medicineId;
  int _notificationId;

  NotificationList(this._medicineId, this._notificationId);

  int get medicineId => _medicineId;
  int get notificationId => _notificationId;

  set medicineId (int newMedicineId){
    this._medicineId = newMedicineId;
  }

  set notificationId (int newNotificationId){
    this._notificationId = newNotificationId;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    map['medicineId'] = _medicineId;
    map['notificationId'] = _notificationId;

    return map;
  }

  NotificationList.fromMap(Map<String, dynamic> map){
    this._medicineId = map['medicineId'];
    this._notificationId = map['notificationId'];
  }
}