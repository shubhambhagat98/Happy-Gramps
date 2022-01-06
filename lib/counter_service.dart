import 'package:flutter/foundation.dart';

//import 'counter.dart';

import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'contacts_new/utils/contact_helper.dart';
import 'package:flutter/services.dart';
import 'package:all_sensors/all_sensors.dart';
import 'dart:math';
import 'dart:async';

class CounterService {
  factory CounterService() => _instance;

  CounterService._internal();

  static final _instance = CounterService._internal();

  // final _counter = Counter();

  bool internet;
  double lat;
  double lng;
  Coordinates coordinates;
  var addresses;
  var first;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  ContactHelper contactHelper = ContactHelper();
  static const platform = const MethodChannel('sendSms');
  bool sent;
  int counter;

  bool fall = false;
  List<double> _accelerometerValues;
  //List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<String> accelerometer = ['0', '0', '0'];
  List<String> gyroscope = ['0', '0', '0'];
  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  //ValueListenable<int> get count => _counter.count;

  void startCounting() async {
    initializeNotifications();

    // i was trying to cancel the subscription but when the startCounting() method is called in background i guess a new subscription is returned
    //so always else condition is executed
    // try to find a way in which we can get previous subscriptions and cancel them

    // if (_streamSubscriptions.isNotEmpty) {
    //   for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
    //     subscription.cancel();
    //   }
    // }else{
    //   print("--------------stream is empty--------------");
    // }

    Stream.periodic(Duration(milliseconds: 500)).listen((_) async {
      // _counter.increment();
      //counter++;
      // print('Counter incremented: ${_counter.count.value}');

       _streamSubscriptions.add(accelerometerEvents.listen((AccelerometerEvent event) {
          _accelerometerValues = <double>[event.x, event.y, event.z];
        }));

      _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
          _gyroscopeValues = <double>[event.x, event.y, event.z];
        }));


      if(_accelerometerValues != null){
      accelerometer =
      _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
      }

      if(_gyroscopeValues != null){
      gyroscope =
      _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
      }

      final xAcc = double.parse(accelerometer[0]);
      final yAcc = double.parse(accelerometer[1]); 
      final zAcc = double.parse(accelerometer[2]);

      double acc = pow(pow(xAcc,2)+pow(yAcc - 9.8,2)+pow(zAcc,2), 0.5);

      //Fetching Gyroscope Values
      final gyX = double.parse(gyroscope[0]);
      final gyY = double.parse(gyroscope[1]);
      final gyZ = double.parse(gyroscope[2]);
      
      //NEW FALL DETECTION
      double lowerTh = 20;
      double upperTh = 30;

      DateTime startAcc;
      DateTime endAcc;

      var startGy;
      var endGy;

      Duration diff = Duration(seconds: 10);

      double angle = 0;

      if (acc > lowerTh){
        print("Lower Threshold crossed");
        angle = pow(pow(gyX,2)+pow(gyY,2)+pow(gyZ,2),0.5);
        startGy = DateTime.now();

        startAcc = DateTime.now();
        if (acc > upperTh){
          print("Upper Threshold crossed");
          endAcc = DateTime.now();
          diff = endAcc.difference(startAcc);
        }
        
        if(diff < Duration(milliseconds: 500)){
          print("Time difference < 0.5");
          sleep(Duration(seconds: 5));

          final gyX2 = double.parse(gyroscope[0]);
          final gyY2 = double.parse(gyroscope[1]);
          final gyZ2 = double.parse(gyroscope[2]);

          double newAngle = pow(pow(gyX2,2)+pow(gyY2,2)+pow(gyZ2,2),0.5);
          if(angle == newAngle){
            print("Orientation condition true. Fall detected");
            // fallDetection();
            try {
              final result = await InternetAddress.lookup('google.com');
              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                print('\nInternet connection is available');
                internet = true;
                await getlocation();
                await sendSms();
              }
            } on SocketException catch (_) {
              print('\nInternet not connected');
              internet = false;
              await sendSms();

            }
          }
        }
      }

      // if(acc > 20){
      //   if(theta > 60){
      //     fall = true;
      //     print('Fall Detected');
      //     print(accelerometer);
      //     await fallDetection();
      //   }
      // }

      // if(fall == true){
      //   await fallDetection();
      //   fall = false;
      // }

      // if(counter > 4 && counter % 5 ==0){
      //   print(accelerometer);
      // }

      // if (_counter.count.value == 25 ) {
      //   await fallDetection();
      // }
      // if (_counter.count.value == 55 ) {
      //   await fallDetection();
      // }


    });
  }

  Future<void>getlocation()async{
    try {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      lat = position.latitude;
      lng = position.longitude;
      coordinates = new Coordinates(lat, lng);
      addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      first = addresses.first;
      //print("$lat, $lng");
      //print("${first.addressLine}");
    } catch (e) {
      print("error");
      print(e);
    }

  }

  Future<Null> sendSms() async{
    String result;
    var printsoslist = await contactHelper.getAlertContactList();

    if (printsoslist.isNotEmpty) { //check if contact list is empty

      if(sent != true){
        for (var item in printsoslist) {
        debugPrint("contact info: name: ${item.name}, number: ${item.phone}, category: ${item.category}\n");

          if (internet == true) { //if internet available, send location
            debugPrint("printing location........");
            debugPrint("${first.addressLine}\n");
            try {
              if(first.addressLine.toString().length > 80){
                result = await platform.invokeMethod('send',<String,dynamic>{"phone":"${item.phone}","msg":"Help-Fall Detected!\nLocation Link: maps.google.com/maps?q=$lat,$lng&z=14"}); //:${first.addressLine} \n\n
              }
              else{
                result = await platform.invokeMethod('send',<String,dynamic>{"phone":"${item.phone}","msg":"Help-Fall Detected!\nLocation: ${first.addressLine}\nLink: maps.google.com/maps?q=$lat,$lng&z=14"}); //
              }
            print(result);
            await showNotification("Fall Detected - Alert has been sent along with your location");
              } on PlatformException catch (e) {
                print(e.toString());
              }

          } else {// no internet
              debugPrint(" Alert sent without location");
              try {
                result = await platform.invokeMethod('send',<String,dynamic>{"phone":"${item.phone}","msg":"Help-Fall Detected!\n\nPlease call me as soon as possible!"}); 
                print(result);
                await showNotification("Fall Detected - Alert sent without location.\n\nTo send sms alert along with your location, please switch on your internet connection");
              } on PlatformException catch (e) {
                print(e.toString());
              }
          }
          
            sent = true;
        
        
        }//for loop
      }

    } else {
       await showNotification("Oops... Contacts not found! \nInsert Contacts with category as SOS or Family!");
       // insert siren.
    }
    sleep(Duration(seconds: 5));
    sent = false;
  }

  Future<Null> fallDetection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('\nInternet connection is available');  
        internet = true;
        await getlocation();
        await sendSms();
      }
    } on SocketException catch (_) {
      print('\nInternet not connected');
      internet = false;
      await sendSms();
    }     
  }//fall detect

   

  //send sms

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

  Future<void> showNotification(var mssg) async {
    var bigTextStyleInformation = BigTextStyleInformation("$mssg");
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Fall detection id', 
        'Fall detection name', 
        'Fall detection description',
        importance: Importance.Max, 
        priority: Priority.High,
        style: AndroidNotificationStyle.BigText,
        styleInformation: bigTextStyleInformation,
        icon: 'notification_icon',
        largeIcon: 'notification_icon',
        largeIconBitmapSource: BitmapSource.Drawable,
      );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 
        'Happy Gramps - Fall Detection', 
        'Notification Body', 
        platformChannelSpecifics,
        );
  }//show notification
}
