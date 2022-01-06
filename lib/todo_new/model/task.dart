class Task {
  int _id;
  String _task, _date, _time, _status, _rawDate, _rawTime, _rawDateTime;

  Task(this._task, this._date, this._time, this._status, this._rawDate, this._rawTime, this._rawDateTime);
  Task.withId(this._id, this._task, this._date, this._time, this._status, this._rawDate, this._rawTime, this._rawDateTime);

  int get id => _id;
  String get task => _task;
  String get date => _date;
  String get time => _time;
  String get status => _status;
  String get rawDate => _rawDate;
  String get rawTime => _rawTime;
  String get rawDateTime => _rawDateTime;

  set task(String newTask) {
    if (newTask.length <= 255) {
      this._task = newTask;
    }
  }

  set date(String newDate) => this._date = newDate;

  set time(String newTime) => this._time = newTime;

  set status(String newStatus) => this._status = newStatus;

  set rawDate(String newRawDate) => this._rawDate = newRawDate;

  set rawTime(String newRawTime) => this._rawTime = newRawTime;

  set rawDateTime(String newRawDateTime) => this._rawDateTime = newRawDateTime;

  //Convert Task object into MAP object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['id'] = _id;
    map['task'] = _task;
    map['date'] = _date;
    map['time'] = _time;
    map['status'] = _status;
    map['rawDate'] = _rawDate;
    map['rawTime'] = _rawTime;
    map['rawDateTime'] = _rawDateTime;
    return map;
  }

  //Extract Task object from MAP object
  Task.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._task = map['task'];
    this._date = map['date'];
    this._time = map['time'];
    this._status = map['status'];
    this._rawDate = map['rawDate'];
    this._rawTime = map['rawTime'];
    this._rawDateTime = map['rawDateTime'];
  }
}
