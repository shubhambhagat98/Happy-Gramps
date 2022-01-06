import 'package:flutter/material.dart';
import 'package:flutter_background/medicine_app/model/medicine.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background/medicine_app/model/notification.dart';
import 'package:flutter_background/medicine_app/util/medicine_helper.dart';


  Color light = Color.fromARGB(255, 242, 59, 95);
  Color dark = Color.fromARGB(255, 37, 58, 75);

class MedicineView extends StatefulWidget{

  final String appBarTitle;
  final Medicine medicine;

  MedicineView(this.medicine, this.appBarTitle);

  @override
  State<StatefulWidget> createState(){
    return MedicineViewState(this.medicine, this.appBarTitle);
  }
}

class MedicineViewState extends State<MedicineView>{

  Medicine medicine;
  
  List<NotificationList> notificationList = List<NotificationList>();
  String appBarTitle;
  MedicineHelper helper = MedicineHelper();

  MedicineViewState(this.medicine, this.appBarTitle);

  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(
            fontSize: 30,
            color: light
          )
        ),
      backgroundColor: dark,
      ),

      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MainSection(medicine: medicine),
              SizedBox(
                height: 15,
              ),
              ExtendedSection(medicine: medicine),
              Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
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
                          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                          color: light,
                          textColor: Colors.white,
                          child: Text(
                            'Check',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () async {
                              await _checkPendingNotificationRequests();
                            } ,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                        ),
                      ),
                    ],
                  ), 
                ),
               
            ],
          ),
        ),
      ),


    );
  }//widget build

  Future<void> _checkPendingNotificationRequests() async {
     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (var pendingNotificationRequest in pendingNotificationRequests) {
      debugPrint(
          'pending notification: [id: ${pendingNotificationRequest.id}, title: ${pendingNotificationRequest.title}, body: ${pendingNotificationRequest.body}, ]');
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              '${pendingNotificationRequests.length} pending notification requests'),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _delete()async{
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
           shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
           title: Text("Delete Reminder"),
           content: Text("Are you sure, you want to delete this reminder?", style: Theme.of(context).textTheme.subhead),
           actions: <Widget>[
             RawMaterialButton(
               onPressed: ()async{
                 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

                 notificationList = await helper.getNotificationList(medicine.id);
                 int count = notificationList.length;
                /* for (int i = 0; i < (24 / medicine.interval).floor(); i++) {
                   
                   flutterLocalNotificationsPlugin.cancel();
                 }*/

                 for (int i = 0; i < count; i++) {
                   flutterLocalNotificationsPlugin.cancel(notificationList[i].notificationId);
                 }
                 await helper.deleteNotification(medicine.id);
                 helper.deleteMedicine(medicine.id);
                 Navigator.pop(context);
                 Navigator.pop(context);
                 _showAlertDialog('Status','Reminder deleted Successfully');  
               },
               child: Text("Yes",textScaleFactor: 1.3,style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.blueAccent)),
             ),
             RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No",textScaleFactor: 1.3,style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.blueAccent)),
              )
           ],
        );
      }
    );
  }

  //alert dialog
  void _showAlertDialog(String title, String message){
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

}


class MainSection extends StatelessWidget{

  final Medicine medicine;
  MainSection({
    Key key,
    @required this.medicine,
  }) : super(key: key);

  Hero makeIcon(double size){
    if (medicine.medicineType == "pill") {
      return Hero(
        tag: medicine.name + medicine.medicineType,
         child: Image.asset(
              'assets/medicine_app/images/pill.png',
               fit: BoxFit.contain,
         ),
      );
    }else if (medicine.medicineType == "tablet") {
      return Hero(
        tag: medicine.name + medicine.medicineType,
         child: Image.asset(
              'assets/medicine_app/images/tablet.png',
               fit: BoxFit.contain,
         ),
      );
    } else if (medicine.medicineType == "syrup") {
      return Hero(
        tag: medicine.name + medicine.medicineType,
         child: Image.asset(
              'assets/medicine_app/images/syrup.png',
               fit: BoxFit.contain,
         ),
      );
    } else if (medicine.medicineType == "syringe") {
      return Hero(
        tag: medicine.name + medicine.medicineType,
         child: Image.asset(
              'assets/medicine_app/images/syringe.png',
               fit: BoxFit.contain,
         ),
      );
    }
    return Hero(
      tag: medicine.name + medicine.medicineType,
      child: Icon(
        Icons.local_hospital,
        color: Color(0xFFF23B5F),
        size: size,
      ),
    );
   
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5.0),
            width: 100,
            height: 100,
            child: makeIcon(175),
          ),
           SizedBox(
            width: 15,
          ),
         
         Expanded(
           child:  Column(
            children: <Widget>[
              Hero(
                tag: medicine.name,
                child: Material(
                  color: Colors.transparent,
                  child: MainInfoTab(
                    fieldTitle: "Medicine Name",
                    fieldInfo: medicine.name,
                  ),
                ),
              ),
              MainInfoTab(
                fieldTitle: "Dosage",
                fieldInfo: medicine.dosage == null
                    ? "Not Specified"
                    : medicine.dosage,
              ),
            ],
          ),
         ),
        ],
      ),
    );
  }
}

class MainInfoTab extends StatelessWidget {

  final String fieldTitle;
  final String fieldInfo;

  MainInfoTab({Key key, @required this.fieldTitle, @required this.fieldInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 100,
      child: ListView(
        padding: EdgeInsets.only(top: 15),
        shrinkWrap: true,
        children: <Widget>[
          Text(
            fieldTitle,
            style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          Text(
            fieldInfo,
            style: TextStyle(
                fontSize: 24,
                color: Color(0xFFF23B5F),
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  final Medicine medicine;

  ExtendedSection({Key key, @required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          ExtendedInfoTab(
            fieldTitle: "Medicine Type",
            fieldInfo: medicine.medicineType == "None"
                ? "Not Specified"
                : medicine.medicineType,
          ),
          ExtendedInfoTab(
            fieldTitle: "Dose Interval",
            fieldInfo: "Every " +
                medicine.interval.toString() +
                " hours  | " +
                " ${medicine.interval == 24 ? "One time a day" : (24 / medicine.interval).floor().toString() + " times a day"}",
          ),
          ExtendedInfoTab(
              fieldTitle: "Start Time",
              fieldInfo: medicine.startTime[0] +
                  medicine.startTime[1] +
                  ":" +
                  medicine.startTime[2] +
                  medicine.startTime[3]),
        ],
      ),
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  ExtendedInfoTab(
      {Key key, @required this.fieldTitle, @required this.fieldInfo})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                fieldTitle,
                style: TextStyle(
                  fontSize: 24,
                  color: dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              fieldInfo,
              style: TextStyle(
                fontSize: 22,
                color: dark,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



