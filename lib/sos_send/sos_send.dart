import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_background/contacts_new/utils/contact_helper.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class SosSend extends StatefulWidget{
  

  @override
  SosSendState createState() => SosSendState();
}

final assetsAudioPlayer = AssetsAudioPlayer();
bool vis = false;
bool isLooping = assetsAudioPlayer.loop;

bool stopSiren = false;


class SosSendState extends State<SosSend>{

  

  ContactHelper contactHelper = ContactHelper();
  static const platform = const MethodChannel('sendSms');
  bool internet;
  double lat;
  double lng;
  Coordinates coordinates;
  var addresses;
  var first;

  Color dark = Color.fromARGB(255, 37, 58, 75);
  Color light = Color.fromARGB(255, 242, 59, 95);

  playSiren(){
    assetsAudioPlayer.openPlaylist(
      Playlist(
        assetAudioPaths : [
        "assets/audio/airhorn.mp3",
        "assets/audio/airhorn.mp3",
        "assets/audio/airhorn.mp3",
        "assets/audio/airhorn.mp3",
        "assets/audio/airhorn.mp3",
        ]
      )
    );
    assetsAudioPlayer.play();
  }

  


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SOS Button",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Ink(
                decoration: ShapeDecoration(
                  color: Colors.red,
                  shape: CircleBorder(),
                ),
                child: Container(
                  height: 240,
                  width: 240,
                  
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(120),
                  ),
                  child: RaisedButton(
                    child: Text('SOS', style: TextStyle(fontSize: 50, color: Colors.white)),
                    splashColor: Colors.redAccent,
                    color: Colors.red,
                    padding: EdgeInsets.all(40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(120),
                    ),
                    
                    onPressed: ()async {

                      vis = true;
                     
                      try {
                        final result = await InternetAddress.lookup('google.com');
                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                          print('\nInternet connection is available');
                          setState(() {
                            internet = true;
                          });

                          await getLocation();
                          await sendSms();
                        }
                      } on SocketException catch (_) {
                        print('\nInternet not connected');
                        setState(() {
                          internet = false;
                        });
                        await sendSms();

                      }
                      
                      playSiren();
                                                                        
                   },
                  ),
                )
              ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
           
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                "Press the button to inform emergency contacts!",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(15.0),
            ),

            //check location button
            Center(
              child: RaisedButton(
                elevation: 0,
                color: Colors.deepOrange,
                textColor: Colors.white,

                onPressed: ()async{
                  try {
                        final result = await InternetAddress.lookup('google.com');
                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                          print('Internet connection is available');
                          setState(() {
                            internet = true;
                          });
                          await checkMyLocation();
                        }
                      } on SocketException catch (_) {
                        print('Internet not connected');
                        setState(() {
                          internet = false;
                          showAlertDialog(context, 'Alert', 'Please check your internet connection!');
                        });

                      }
                
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                    "Check My Location", 
                    style: TextStyle(
                      fontSize: 24, 
                      color: Colors.white
                    )
                  )
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10.0),
            ),

            //stop siren button
             Visibility(
              visible: vis,
              child: Container(
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  color: Colors.green,
                  onPressed: (){assetsAudioPlayer.stop(); vis = false; stopSiren = true;},
                  child: Text('Press to stop the siren', style: TextStyle(fontSize: 24, color: Colors.white),),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }// widget build

  //getLoaction method
  getLocation() async{
    

    try {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      lat = position.latitude;
      lng = position.longitude;
     
      final coordinates = new Coordinates(lat, lng);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      first = addresses.first;
      
     // print("${first.featureName} : ${first.addressLine}");
      
    } catch (e) {
      print("error");
      print(e);
    }
  }// get loaction

  //send sms method with location
  Future<Null> sendSms() async{
     String result;
    //printing sos contact
    
    var printsoslist = await contactHelper.getAlertContactList();

    if (printsoslist.isNotEmpty) { //check if contact list is empty

      for (var item in printsoslist) {
       debugPrint("contact info: name: ${item.name}, number: ${item.phone}, category: ${item.category}\n");

        if (internet == true) { //if internet available, send location
          debugPrint("printing location........");
          debugPrint("${first.addressLine}\n");
          try {
          result = await platform.invokeMethod('send',<String,dynamic>{"phone":"${item.phone}","msg":"Help needed!\nLocation:${first.addressLine} \nLink: maps.google.com/maps?q=$lat,$lng&z=14"}); 
          print(result);
            } on PlatformException catch (e) {
              print(e.toString());
            }

        } else {// no internet
            debugPrint(" Alert sent without location");
            try {
              result = await platform.invokeMethod('send',<String,dynamic>{"phone":"${item.phone}","msg":"Help needed!\n\nPlease call me as soon as possible!"}); 
              print(result);
            } on PlatformException catch (e) {
              print(e.toString());
            }
        }
       
      }//for loop

        
          if (internet == true) {
            showAlertDialog(context, 'Relax...', 'Emergency alert has been sent along with your location!');
          } else {
            showAlertDialog(context, 'Relax...', 'Alert sent without location.\n\nTo send sms alert along with your location, please switch on your internet connection');
          }
        

    } else {
       showAlertDialog(context, 'Oops...', 'Insert Contacts with category as SOS or Family!');
       // insert siren.
    }
  }
  

  //my location alert
  checkMyLocation() async{
    

    try {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      lat = position.latitude;
      lng = position.longitude;
     
      coordinates = new Coordinates(lat, lng);
      addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      first = addresses.first;
     // print("${first.featureName} : ${first.addressLine}");
      showAlertDialog(context, 'Your Location', '${first.addressLine}');
    } catch (e) {
      print("error");
      print(e);
      showAlertDialog(context, 'Alert', 'Please check your internet connect!');
    }

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


}