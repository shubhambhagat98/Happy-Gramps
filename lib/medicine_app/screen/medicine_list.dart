import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter_background/medicine_app/model/medicine.dart';

import 'package:flutter_background/medicine_app/util/medicine_helper.dart';
import 'package:flutter_background/medicine_app/screen/medicine_view.dart';
import 'package:flutter_background/medicine_app/screen/medicine_detail.dart';

Color light = Color.fromARGB(255, 242, 59, 95);
Color dark = Color.fromARGB(255, 37, 58, 75);

class MedicineList extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){
    return MedicineListState();
  }
}

class MedicineListState extends State<MedicineList>{

  MedicineHelper medicineHelper = MedicineHelper();
  List<Medicine> medicineList;
  int count = 0;
  
  @override
  Widget build(BuildContext context){

    updateListView();
    if (medicineList == null) {
      medicineList = List<Medicine>();
      updateListView();
      
    }

    return Scaffold(
      appBar: AppBar(
         title: Text(
           'Medicine Reminder',
           style: TextStyle(
             fontSize: 30,
             color: light
           ),
       ),
       backgroundColor: dark,
      ),
      body: new Container(
        child: ListView(
        
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height -76,
              child: FutureBuilder(
                future: medicineHelper.getMedicineList(),
                
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if (snapshot.data == null) {
                          return Text("Loading");
                    } else {
                      if (snapshot.data.length < 1) {
                            return Center(
                              child: Text(
                                'No Reminder Added',
                                style: TextStyle(fontSize: 20),
                                ),
                            );
                        }}
                  return GridView.builder(
                    
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical:6.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemCount: count,
                    physics: BouncingScrollPhysics(),
                    itemBuilder:  (BuildContext context, int position) => GestureDetector(
                      onTap: () async{
                         navigateToView(snapshot.data[position], 'Reminder Details');
                          print("printing notification list after tap.......");
                          var printList = await medicineHelper.getNotificationList(snapshot.data[position].id);
                          for (var item in printList) {
                            debugPrint('medicine id: ${item.medicineId}, notification id : ${item.notificationId}');
                          }
                         
                      },

                      child: Card(
                        
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                          
                              Container(
                                margin: EdgeInsets.all(10),
                                width: 50,
                                height: 50,
                               /* child: Hero(
                                  tag: snapshot.data[position].name + snapshot.data[position].medicineType ,
                                  child: Image.asset(
                                    'assets/medicine_app/images/pill.png',
                                     fit: BoxFit.contain,
                                    ),
                                ),*/

                                 child: makeIcon(175,snapshot.data[position].medicineType, snapshot.data[position].name),
                              ),
                              Hero(
                                tag: snapshot.data[position].name,
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    
                                    snapshot.data[position].name,
                                    style: TextStyle(fontSize: 22, color: light, fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            
                              Text(
                                
                                snapshot.data[position].interval == 1
                                  ? "Every " + snapshot.data[position].interval.toString() + " hour"
                                  : "Every " + snapshot.data[position].interval.toString() + " hours",
                                style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w400),
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Container(
        height: 75,
        width: 75,
        child: FloatingActionButton(
          onPressed: (){
            //navigateToDetail(Medicine(null, "", null, "", null), "Add Reminder");
            navigateToDetail(Medicine("", null, ""), "Add Reminder");
          },
          tooltip: 'Add Reminder',
          child: Icon(Icons.add, size: 32, color: light),
          backgroundColor: dark,
        ),
      ),
    );
  }// widget build

  Hero makeIcon(double size, String medicineType, String name){
    if (medicineType == "pill") {
      return Hero(
        tag: name + medicineType,
         child: Image.asset(
              'assets/medicine_app/images/pill.png',
               fit: BoxFit.contain,
         ),
      );
    }else if (medicineType == "tablet") {
      return Hero(
        tag: name + medicineType,
         child: Image.asset(
              'assets/medicine_app/images/tablet.png',
               fit: BoxFit.contain,
         ),
      );
    } else if (medicineType == "syrup") {
      return Hero(
        tag: name + medicineType,
         child: Image.asset(
              'assets/medicine_app/images/syrup.png',
               fit: BoxFit.contain,
         ),
      );
    } else if (medicineType == "syringe") {
      return Hero(
        tag: name + medicineType,
         child: Image.asset(
              'assets/medicine_app/images/syringe.png',
               fit: BoxFit.contain,
         ),
      );
    }
    return Hero(
      tag: name + medicineType,
      child: Icon(
        Icons.local_hospital,
        color: Color(0xFFF23B5F),
        size: size,
      ),
    );   
  }

  void updateListView(){
    final Future<Database> dbFuture = medicineHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Medicine>> medicineListFuture = medicineHelper.getMedicineList();
      medicineListFuture.then((medicineList){
        setState(() {
          this.medicineList = medicineList;
          this.count = medicineList.length;
        
        });
      });
    });
  }

  void navigateToView(Medicine medicine, String title)async{
    
    await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context){ return MedicineView(medicine, title);}));
    
  } 

  void navigateToDetail(Medicine medicine, String title) async{
    bool result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context){ return MedicineDetail(medicine, title);}));
    if (result == true) {
      updateListView();
    } 
  }
}