import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background/medicine_app/model/medicine.dart';
import 'package:flutter_background/medicine_app/model/notification.dart';
import 'package:flutter_background/medicine_app/util/medicine_helper.dart';
import 'dart:async';
import 'dart:typed_data';

class MedicineDetail extends StatefulWidget{
  final String appBarTitle;
  final Medicine medicine;

  MedicineDetail(this.medicine, this.appBarTitle);

  @override
  State<StatefulWidget> createState(){
    return MedicineDetailState(this.medicine, this.appBarTitle);
  }
}

class MedicineDetailState extends State<MedicineDetail>{

  MedicineDetailState(this.medicine, this.appBarTitle);
  MedicineHelper helper = MedicineHelper();
  Medicine medicine;
  String appBarTitle;
  bool edited = false;
  TimeOfDay time = new TimeOfDay.now();
  bool editTime = false;
  String startTime ="";
    
  String medicineType = "syrup";
  int iconListIndex = 0;
  List<String> iconList = ['syrup', 'pill', 'tablet', 'syringe'];
  List<int> notificationIDs;
  NotificationList notification;

  TextEditingController nameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  var intervals = [ 6, 8, 12, 24,];
  var selectedInterval = 0;
  

  void initState(){
    super.initState();
    initializeNotifications();

  }
  /*void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    
  }*/

  Color light = Color.fromARGB(255, 242, 59, 95);
  Color dark = Color.fromARGB(255, 37, 58, 75);
  @override
  Widget build(BuildContext context){

    

    
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return WillPopScope(
      onWillPop: requestPop,
      child: Scaffold(
        appBar: AppBar(
         title: Text(
            appBarTitle,
            style: TextStyle(
              fontSize: 30,
              color: light
            ),
          ),
          backgroundColor: dark,
        ),

        body: Padding(
          padding:EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
          child: ListView(
            children: <Widget>[
              //first element - medicine name
              Padding(
                padding: EdgeInsets.only( top: 10.0,bottom: 10.0),
                child: TextField(
                  maxLength: 255,
                  controller: nameController,
                  style: textStyle,
                  onChanged: (value){
                    edited = true;
                   // debugPrint("name changed");
                    updateName();
                  },
                  decoration: InputDecoration(
                    labelText: "Medicine Name",
                    labelStyle: TextStyle(fontSize: 24, color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                  ),
                ),
              ),

              //second element - dosage
              Padding(
                padding: EdgeInsets.only( bottom: 5.0),
                child: TextField(
                  maxLength: 255,
                  controller: dosageController,
                  style: textStyle,
                  onChanged: (value){
                    edited = true;
                    //debugPrint("dosage changed");
                    updateDosage();
                  },
                  decoration: InputDecoration(
                    labelText: "Medicine Dosage",
                    labelStyle: TextStyle(fontSize: 24, color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                  ),
                ),
              ),

              //third element - medicinetype
              _buildShapesList(),

              //fourth element - interval dropdown
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Remind me every  ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButton<int>(
                        iconEnabledColor: Color(0xFFF23B5F),
                        hint: selectedInterval == 0
                          ? Text(
                              "Select an Interval",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: light,
                                  fontWeight: FontWeight.bold),
                            )
                          : null,
                        elevation: 4,
                        value: selectedInterval == 0 ? null : selectedInterval,
                        items: intervals.map((int value){
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newVal){
                          setState(() {
                            selectedInterval = newVal;
                            updateInterval();
                          });
                        },
                      ),
                      Text(
                        selectedInterval == 1 ? " hour" : " hours",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //fifth element - time picker

              //last element - Save Button
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Center(
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                    color: dark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                        editTime == false
                          ? "Pick Time"
                          : "${startTime[0]}${startTime[1]}:${startTime[2]}${startTime[3]}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    onPressed: (){
                      selectTime(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.all(10)),
              
              Container(
                child: Center(
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(70, 20, 70, 20),
                    color: light,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      'Save',
                      textScaleFactor: 1.5,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: (){
                      print('Save pressed');
                      save();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }//widget build


  //discard change alert
  Future<bool> requestPop() {
    if(edited) {
      showDialog(context: context,
      builder: (context) {
        return AlertDialog (
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text('Discard Changes'),
          content: Text('If you leave the changes will be lost!', style: Theme.of(context).textTheme.subhead,),
          actions: <Widget>[
            FlatButton (
               child: Text("Cancel",textScaleFactor: 1.3),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Yes",textScaleFactor: 1.3),
              onPressed: () {
              //  Navigator.pushAndRemoveUntil(
              //     context, 
              //     MaterialPageRoute(builder: (context) => MedicineList()),
              //     (Route<dynamic> route) => false,);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        );
      });

      return Future.value(false);
    } else {
      return Future.value(true);
    }  
  }

  Widget _buildShapesList() {
    return Container(
      width: double.infinity,
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: iconList
            .asMap()
            .entries
            .map((MapEntry map) => _buildIcons(map.key))
            .toList(),
      ),
    );
  }

  Widget _buildIcons(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          iconListIndex = index;
          medicineType = iconList[iconListIndex];
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.2),
        
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                  padding: EdgeInsets.all(15),
                  height: 80,
                  width: 75,
                  decoration: BoxDecoration(
                    color: (index == iconListIndex)
                        //? Theme.of(context).accentColor.withOpacity(.3)
                        ? Color(0xFFF23B5F).withOpacity(.2)
                        //? dark.withOpacity(0.3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset('assets/medicine_app/images/'+iconList[index]+'.png'),
                ),
            ),

              Text(iconList[index], 
              overflow: TextOverflow.ellipsis, 
              style: TextStyle(fontSize: 18, color: light, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  Future<Null> selectTime (BuildContext context) async{
      final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: time
      );

      if (picked != null && picked != time) {
        print('Time selected: ${time.toString()}');
        setState(() {
          time = picked;
          editTime = true;
          startTime = updateTime();
          debugPrint(startTime);
        });
      }
    }

  String updateTime(){
    
    String hour, minute;

    if(time.hour.toString().length ==1){
      hour = '0' + time.hour.toString();
    }else{
      hour = time.hour.toString();
    }


    if(time.minute.toString().length ==1){
      minute = '0' + time.minute.toString();
    }else{
      minute = time.minute.toString();
    }

    return hour + minute;
    
    
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
    /*await  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (context) => MedicineList()),
                    (Route<dynamic> route) => false,
                  );*/
   /* await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => MedicineList()),
    );*/
  }

  //create list of id
   List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000));
    }
    return ids;
  }

  //alert dialog
  void showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }

  void updateInterval(){
    medicine.interval = selectedInterval;
  }

  void updateDosage(){
    medicine.dosage = dosageController.text;
  }

  void updateName(){
    medicine.name = nameController.text;
  }

  void save() async{
    print('inside Save function');
    int result;
    String check = checkError();

      if (check == "noerror") {
        notificationIDs = makeIDs(24 / selectedInterval);
        medicine.startTime = startTime;
        medicine.medicineType = medicineType;
        await scheduleNotification(medicine, notificationIDs);
        result = await helper.insertMedicine(medicine);
       

        //insert notification
        for (var i = 0; i < notificationIDs.length; i++) {
          //notification.medicineId = result;
          //notification.notificationId = notificationIDs[i];
          await helper.insertNotification(result, notificationIDs[i]);
        }

        print("printing notification list just after insert.......");
        var printList = await helper.getNotificationList(result);
        for (var item in printList) {
          debugPrint('medicine id: ${item.medicineId}, notification id : ${item.notificationId}');
         }
        
        Navigator.pop(context, true);

        if (result != 0) {//success
          showAlertDialog('Status','Reminder Saved Successfully');
        } else {//failure
          showAlertDialog('Status','Problem Saving the reminder');
        }
      } 
  }

  Future<void> scheduleNotification(Medicine medicine, List<int> notificationIDs) async {
    var hour = int.parse(medicine.startTime[0] + medicine.startTime[1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime[2] + medicine.startTime[3]);
    var vibrationPattern = Int64List(7);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 1000;
    vibrationPattern[3] = 1000;
    vibrationPattern[4] = 1000;
    vibrationPattern[5] = 1000;
    vibrationPattern[6] = 1000;

    var bigTextStyleInformation = BigTextStyleInformation( medicine.medicineType.toString() != ""
              ? 'It is time to take your ${medicine.medicineType.toLowerCase()}, according to schedule'
              : 'It is time to take your medicine, according to schedule');

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Medicine reminder channel id',
      'Medicine reminder channel name',
      'Medicine reminder description',
      importance: Importance.Max,
      priority: Priority.Max,
      style: AndroidNotificationStyle.BigText,
      styleInformation: bigTextStyleInformation,
      icon: 'notification_icon',
      largeIcon: 'notification_icon',
      largeIconBitmapSource: BitmapSource.Drawable,
      vibrationPattern: vibrationPattern,
      //sound: 'sound',
      ledColor: Color(0xFFF23B5F),
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    for (int i = 0; i < (24 / medicine.interval).floor(); i++) {
      if ((hour + (medicine.interval * i) > 23)) {
        hour = hour + (medicine.interval * i) - 24;
      } else {
        hour = hour + (medicine.interval * i);
      }
     
      await flutterLocalNotificationsPlugin.showDailyAtTime(
          notificationIDs[i],
          'Happy Gramps: ${medicine.name}',
          medicine.medicineType.toString() != ""
              ? 'It is time to take your ${medicine.medicineType.toLowerCase()}, according to schedule'
              : 'It is time to take your medicine, according to schedule',
          Time(hour, minute, 0),
          platformChannelSpecifics, );
      hour = ogValue;
    }
    //await flutterLocalNotificationsPlugin.cancelAll();
  }

  String checkError(){
    String name = nameController.text;
    String check;
    if(name.isEmpty){
      showAlertDialog('Oops...','Name cannot be empty!');
      check = "error";
    }else if (selectedInterval == 0) {
      showAlertDialog('Oops...','Please select the interval!');
      check = "error";
    }else if (startTime == "") {
      showAlertDialog('Oops...','Please pick the time!');
      check = "error";
    }else{
      check = "noerror";
    }

    return check;
  }
}