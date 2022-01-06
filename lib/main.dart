import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/app_retain_widget.dart';
import 'package:flutter_background/background_main.dart';
import 'package:flutter_background/counter_service.dart';

//import 'package:all_sensors/all_sensors.dart';
//import 'dart:math';

import 'package:flutter_background/todo_new/screens/todo_list.dart';
import 'package:flutter_background/notebook_new/screens/note_list.dart';
import 'package:flutter_background/medicine_app/screen/medicine_list.dart';
import 'package:flutter_background/sos_send/sos_send.dart';
import 'package:flutter_background/contacts_new/screens/contact_list.dart';

Color dark = Color.fromARGB(255, 37, 58, 75);
Color light = Color.fromARGB(255, 242, 59, 95);


void main() async {
  runApp(MyApp());

  var channel = const MethodChannel('com.example/background_service');
  var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
  channel.invokeMethod('startService', callbackHandle.toRawHandle());

  CounterService().startCounting();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Background Demo',
      home: AppRetainWidget(
        child: MyHomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
            alignment: Alignment(0,0),
            child: Text('Happy Gramps',
              style: TextStyle(
                  color: light,
                  fontWeight: FontWeight.bold,
                  fontSize: 40
                ),
              ),
          ),
            
            backgroundColor: dark,
            elevation: 0,
        ),
      body: ListView(
        children: <Widget>[
          //app slogan
          Container(
              padding: EdgeInsets.fromLTRB(10,2,0,10),
              alignment: Alignment(0, 0),
              height: 75,
              child: Text('Your Safety, Our Priority',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Verdana'
                  ),
                ),
              decoration: BoxDecoration(
                color: dark,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)
                )
              )
            ),

            //white space
            Padding(
              padding: EdgeInsets.all(15),
            ),

            //button container
            Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20
              ),
              child: Column(
                children: <Widget>[
                  //medicine button
                  RaisedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MedicineList()),
                      );
                    },
                    //padding: EdgeInsets.fromLTRB(70,15,60,15),
                    padding: EdgeInsets.fromLTRB(45,15,0,15),
                    color: Colors.green,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          size: 48,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 20
                          ),
                        ),
                        Text(
                          'Medicines',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                      
                    ),
                  ),
                  
                  //white space
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 20,
                    ),
                  ),

                  //contact button
                  RaisedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContactList()),
                      );
                    },
                    padding: EdgeInsets.fromLTRB(45,15,0,15),
                    color: Colors.blueAccent[400],
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.local_phone,
                          size: 48,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 20
                          ),
                        ),
                        Text(
                          'Contacts',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                  ),

                  //whitespace
                   Padding(
                    padding: EdgeInsets.only(
                      bottom: 20,
                    ),
                  ),

                  //notebook button
                  RaisedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NoteList()),
                      );
                    },
                    padding: EdgeInsets.fromLTRB(45,15,0,15),
                    color: Colors.yellow[700],
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.library_books,
                          size: 48,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 20
                          ),
                        ),
                        Text(
                          'Notebook',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                  ),

                  //white space
                   Padding(
                    padding: EdgeInsets.only(
                      bottom: 20,
                    ),
                  ),

                  //todo task button
                  RaisedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TodoList()),
                      );
                    },
                    padding: EdgeInsets.fromLTRB(45,15,0,15),
                    color: Colors.purple,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.alarm,
                          size: 48,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 20
                          ),
                        ),
                        Text(
                          'To-do Tasks',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                  ),

                  //white space
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 20,
                    ),
                  ),

                  //sos button
                   RaisedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SosSend()),
                      );
                    },
                    //padding: EdgeInsets.fromLTRB(70,15,60,15),
                    padding: EdgeInsets.fromLTRB(45,15,0,15),
                    color: Colors.redAccent [700],
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.sentiment_dissatisfied,
                          size: 48,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 20
                          ),
                        ),
                        Text(
                          'SOS Button',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                      
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
