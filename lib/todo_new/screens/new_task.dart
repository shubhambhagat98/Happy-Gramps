import 'package:flutter/material.dart';
import 'package:flutter_background/todo_new/util/todo_database.dart';
import 'package:flutter_background/todo_new/model/task.dart';
import 'package:flutter_background/todo_new/screens/todo_list.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

var globalDate = "Pick Date";

Color dark = Color.fromARGB(255, 37, 58, 75);
Color light = Color.fromARGB(255, 242, 59, 95);

class NewTask extends StatefulWidget {
  final String appBarTitle;
  final Task task;
  TodoState todoState;
  NewTask(this.task, this.appBarTitle, this.todoState);


  @override
  State<StatefulWidget> createState() {
    return TaskState(this.task, this.appBarTitle, this.todoState);
  }
}

class TaskState extends State<NewTask> {


  TodoState todoState;
  String appBarTitle;
  Task task;
  List<Widget> icons;
  TaskState(this.task, this.appBarTitle, this.todoState);

  

  bool marked = false;
  bool dateEdit = false;
  bool timeEdit = false;

  TextStyle titleStyle = new TextStyle(
    fontSize: 18,
    fontFamily: "Lato",
  );

  TextStyle buttonStyle =
      new TextStyle(fontSize: 24, fontFamily: "Lato", color: Colors.white);

  final scaffoldkey = GlobalKey<ScaffoldState>();

  DatabaseHelper helper = DatabaseHelper();
  //Utils utility = new Utils();
  TextEditingController taskController = new TextEditingController();


  var formattedDate = "Pick Date";
  var formattedTime = "Select Time";
  
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: null, minute: null);
  DateTime finalDateTime;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initState(){
    super.initState();
    initializeNotifications();

  }


  @override
  Widget build(BuildContext context) {
    taskController.text = task.task;
    return Scaffold(
        key: scaffoldkey,
        appBar: AppBar(
          backgroundColor: dark,
          leading: new GestureDetector(
            child: Icon(Icons.close, size: 30),
            onTap: () {
              Navigator.pop(context);
              todoState.updateListView();
            },
          ),
          title: Text(appBarTitle, style: TextStyle(fontSize: 30, color: light)),
        ),
        body: ListView(children: <Widget>[
          
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              style: TextStyle(
                fontSize: 24
              ),
              controller: taskController,
              decoration: InputDecoration(
                  labelText: "Task",
                  hintText: "E.g.  Pick Julie from School",
                  labelStyle: TextStyle(
                    fontSize: 24,
                    color: dark,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold,
                  ),
                  hintStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: "Lato",
                      fontStyle: FontStyle.italic,
                      color: Colors.grey)), //Input Decoration
              onChanged: (value) {
                updateTask();
              },
            ), //TextField
          ), //Padding

       ListTile(
            title: task.date.isEmpty
                ? Text(
                  
                    "Pick Date",
                    style: TextStyle(
                      fontSize: 24,
                      color: dark,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                  task.date,
                  style: TextStyle(
                    fontSize: 20,
                    color: dark,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold,
                  ),
                ),
            subtitle: Text(""),
            trailing: Icon(Icons.calendar_today, size: 36),
            onTap: () async {
              var pickedDate = await selectDate(context, task.date);
              if (pickedDate != null && pickedDate.isNotEmpty)
                setState(() {
                  this.formattedDate = pickedDate.toString();
                  task.date = formattedDate;
                  debugPrint(task.date + " task.date");
                });
            },
          ), //DateListTile

          ListTile(
            title: task.time.isEmpty
                ? Text(
                    "Select Time",
                    style: TextStyle(
                    fontSize: 24,
                    color: dark,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold,
                  ),
                  )
                : Text(
                  task.time,
                  style: TextStyle(
                      fontSize: 20,
                      color: dark,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            subtitle: Text(""),
            trailing: Icon(Icons.access_time, size: 36),
            onTap: () async {
              var pickedTime = await selectTime(context);
              if (pickedTime != null && pickedTime.isNotEmpty)
                setState(() {
                  formattedTime = pickedTime;
                  task.time = formattedTime;
                  debugPrint(task.time + " task.time");
                });
            },
          ), //TimeListTile

          Padding(
            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
            child: Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: _isEditable() ?  Container(
                child: CheckboxListTile(
                    title: Text(
                      "Mark as Done",
                      style: TextStyle(
                        fontSize: 22,
                        color: light
                      )
                    ),
                    value: marked,
                    dense: true,
                    checkColor: light,
                    activeColor: Colors.white,
                    onChanged: (bool value) {
                     setState(() {
                       marked = value;
                     });
                    }
                    ),
              )//CheckboxListTile
              : Container(height: 2,)
            ),
          ),

          Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 15.0, left: 10.0, right: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                          color: dark,
                          textColor: Colors.white,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed:(){
                            setState(() {
                              debugPrint('delete button clicked');
                              _delete();
                            });
                          } ,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                        ),
                      
                      ),

                      Container(width: 10.0,),

                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                          color: light,
                          textColor: Colors.white,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed:(){
                            setState(() {
                              debugPrint('save button clicked');
                              _save();
                            });
                          } ,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                        ),
                      ),
                    ],
                  ), 
                ), //Padding

          
        ]) //ListView

        ); //Scaffold
  } //build()

  void markedDone() {}

  bool _isEditable() {
    if (this.appBarTitle == "Add Task")
      return false;
    else {
      return true;
    }
  }

  void updateTask() {
    task.task = taskController.text;
  }

  //InputConstraints
  bool _checkNotNull() {
    bool res;
    if (taskController.text.isEmpty) {
      showAlertDialog(context, 'Oops...', 'Task cannot be empty');
      res = false;
    } else if (task.date.isEmpty) {
      showAlertDialog(context, 'Oops...', 'Please select date ');
      res = false;
    } else if (task.time.isEmpty) {
      showAlertDialog(context, 'Oops...', 'Please select time');
      res = false;
    }else {
      res = true;
    }
    return res;
  }


  //initialize notification
   void initializeNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  //onselect notification action
   Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }
  //schedule notification

  Future<void> scheduledTestNotification(int id, Task task,
      DateTime date) async {
    var scheduledNotificationDateTime = date;
    var vibrationPattern = Int64List(7);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 1000;
    vibrationPattern[3] = 1000;
    vibrationPattern[4] = 1000;
    vibrationPattern[5] = 1000;
    vibrationPattern[6] = 1000;
    var bigTextStyleInformation = BigTextStyleInformation("Its time to complete task : ${task.task}");
    debugPrint(id.toString() +" " + date.toString() +" before schdule");
    //debugPrint(DateTime.now().toString());
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'To-Do Channel id',
        'To-Do Channel name',
        'To-Do Channel Notifications',
        style: AndroidNotificationStyle.BigText,
        styleInformation: bigTextStyleInformation,
        icon: 'notification_icon',
        largeIcon: 'notification_icon',
        largeIconBitmapSource: BitmapSource.Drawable,
        vibrationPattern: vibrationPattern,
        ledColor: const Color.fromARGB(255, 255, 0, 164),
        ledOnMs: 1000,
        ledOffMs: 1000,
        enableLights: true,
        importance: Importance.Max, 
        priority: Priority.High,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics,
        iOSPlatformChannelSpecifics
    );

    await flutterLocalNotificationsPlugin.schedule(
        id,
        "Happy Gramps: To-Do Task",
        'notification body',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        
    );
  }
  //Save data
  void _save() async {
    int result;

    
    if(_isEditable()) {
      if (marked) {
        task.status = "Task Completed";
      }
      else
        task.status = "";
    }
   


    if (_checkNotNull() == true) {
      if (task.id != null) {
        debugPrint(task.rawDateTime + " rawdatetime after task complete");
        debugPrint(task.rawTime + " raw time after task complete");
        debugPrint(task.rawDate + " raw date after task complete");
        //Update Operation
        if (task.status == "Task Completed") {
          if (DateTime.now().isBefore(DateTime.parse(task.rawDateTime))) {
            flutterLocalNotificationsPlugin.cancel(task.id);
          } 
          //flutterLocalNotificationsPlugin.cancel(task.id);
        }else if (task.status == "") {

          if (dateEdit == true && timeEdit == false) { //only date is changed
            flutterLocalNotificationsPlugin.cancel(task.id);
            finalDateTime = constructDate(selectedDate, TimeOfDay(hour:int.parse(task.rawTime.split(":")[0]),minute: int.parse(task.rawTime.split(":")[1])));
            task.rawDateTime = finalDateTime.toString();
            await scheduledTestNotification(task.id, task, finalDateTime);

          } else if (dateEdit == false && timeEdit == true){ //only time is changed
            flutterLocalNotificationsPlugin.cancel(task.id);
            finalDateTime = constructDate(DateTime.parse(task.rawDate), selectedTime);
            task.rawDateTime = finalDateTime.toString();
            await scheduledTestNotification(task.id, task, finalDateTime);

          } else if (dateEdit == true && timeEdit == true) { //both date and time are changed
            flutterLocalNotificationsPlugin.cancel(task.id);
            finalDateTime = constructDate(selectedDate, selectedTime);
            task.rawDateTime = finalDateTime.toString();
            await scheduledTestNotification(result, task, finalDateTime);
          }
        }
        result = await helper.updateTask(task);
      } else {
        //Insert Operation
        
        finalDateTime = constructDate(selectedDate, selectedTime);
        task.rawDateTime = finalDateTime.toString();
        debugPrint(task.rawDateTime + " rawdate time set before insert");
        debugPrint(task.rawDate + " " + task.rawTime + " raw date n time test before insert");
        result = await helper.insertTask(task);

        //call schedule notification here    
        await scheduledTestNotification(result, task, finalDateTime);
        
      }

      todoState.updateListView();

      Navigator.pop(context);

      if (result != 0) {
        debugPrint(result.toString() + " after update/insert");
        showAlertDialog(context, 'Status', 'Task saved successfully.');
      } else {
       showAlertDialog(context, 'Status', 'Problem saving task.');
      }
    }
  } //_save()

  void _delete() {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure, you want to delete this task?"),
            actions: <Widget>[
              RawMaterialButton(
                onPressed: () async {
                  //check if deleting the task before scheduled time.
                  if (DateTime.now().isBefore(DateTime.parse(task.rawDateTime))) {
                    flutterLocalNotificationsPlugin.cancel(task.id);
                  } 
                  //flutterLocalNotificationsPlugin.cancel(task.id);
                  await helper.deleteTask(task.id);
                  todoState.updateListView();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  showAlertDialog(context, 'Status', 'Task Deleted Sucessfully');
                },
                child: Text("Yes"),
              ),
              RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"),
              )
            ],
          );
        });
  }

  //alert dialog
  void showAlertDialog(
    BuildContext context, String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
     
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  //snackbar
  void showSnackBar(var scaffoldkey, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1, milliseconds: 500),
    );
    scaffoldkey.currentState.showSnackBar(snackBar);
  }

  //select date
  Future<String> selectDate(BuildContext context, String date) async {
    final DateTime picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2020),
        initialDate: date.isEmpty
            ? DateTime.now()
            : new DateFormat("d MMM, y").parse(date),
        lastDate: DateTime(2021));
        if (picked != null){
          //debugPrint(picked.toString() + " before date format");
          setState(() {
            dateEdit = true;
            selectedDate = picked;
            task.rawDate = selectedDate.toString();
            debugPrint(task.rawDate + "rawdate set");
          });
          debugPrint(selectedDate.toString() + " selected date");
          return formatDate(picked);
        }
          

    return "";
  }

  //select time
  Future<String> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      //initialTime: task.time.isEmpty ? _initialTime : new TimeOfDay().parse(task.time),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if (picked != null){
      //debugPrint(picked.toString() + " before time format");
      setState(() {
        timeEdit = true;
        selectedTime = picked;
        task.rawTime = updateTime(selectedTime);
      });
      debugPrint(task.rawTime.toString()+ " raw time set");
      return timeFormat(picked);
    }

    return "";
  }

  //format time
  String timeFormat(TimeOfDay picked){

    var hour = 00;
    var time = "PM";
    if (picked.hour >= 12) {
      time = "PM";
      if (picked.hour > 12) {
        hour = picked.hour - 12;
      } else if (picked.hour == 00) {
        hour = 12;
      } else {
        hour = picked.hour;
      }
    } else {
      time = "AM";
      if (picked.hour == 00) {
        hour = 12;
      } else {
        hour = picked.hour;
      }
    }
    var h, m;
    if (hour % 100 < 10) {
      h = "0" + hour.toString();
    } else {
      h = hour.toString();
    }

    int minute = picked.minute;
    if (minute % 100 < 10)
      m = "0" + minute.toString();
    else
      m = minute.toString();

    return h + ":" + m + " " + time;
  }

  //format date
  String formatDate(DateTime selectedDate) =>
      new DateFormat("d MMM, y").format(selectedDate);
  
  //construct date
  DateTime constructDate(DateTime date, TimeOfDay time) {
    if (date == null){
      return null;
    }

    if (date != null && time == null){
      return new DateTime(date.year, date.month, date.day);
    }

    return new DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String updateTime(TimeOfDay _time){
    
    String hour, minute;

    if(_time.hour.toString().length ==1){
      hour = '0' + _time.hour.toString();
    }else{
      hour = _time.hour.toString();
    }


    if(_time.minute.toString().length ==1){
      minute = '0' + _time.minute.toString();
    }else{
      minute = _time.minute.toString();
    }

    return hour + ":" + minute;
    
    //debugPrint("${_startTime[0]}: ${_startTime[1]}" );
  }

} //class TaskState
