import 'package:flutter/material.dart';
import 'package:flutter_background/contacts_new/utils/contact_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter_background/contacts_new/models/contact.dart';

import 'package:flutter_background/contacts_new/screens/contact_view.dart';
import 'package:flutter_background/contacts_new/screens/contact_detail.dart';
import 'dart:io';


class ContactList extends StatefulWidget{

  @override
   State<StatefulWidget> createState(){
     return ContactListState();
   }
}

class ContactListState extends State<ContactList>{

  Color dark = Color.fromARGB(255, 37, 58, 75);
  Color light = Color.fromARGB(255,242,59,95);

  ContactHelper contactHelper = ContactHelper();
  List<Contact> contactList;
  int count = 0;

  @override
  Widget build(BuildContext context){

    updateListView();
     if (contactList == null) {
       contactList = List<Contact>(); 
       updateListView();

     }

    return Scaffold(
      appBar: AppBar(
         title: Text('Contacts', style: TextStyle(fontSize: 30, color: light),),
         backgroundColor: dark,
       ),

      body: new Container(
        //padding: EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height - 76,
              child: FutureBuilder(
                future: contactHelper.getContactList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                   if (snapshot.data == null) {
                          return  Center(
                            child: CircularProgressIndicator(backgroundColor: Colors.lightBlue,),
                          );
                    } else {
                        if (snapshot.data.length < 1) {
                              return Center(
                                child: Text(
                                  'No Contacts Added',
                                  style: TextStyle(fontSize: 20),
                                  ),
                              );
                          }
                       }

                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int position){
                      return new GestureDetector(
                        onTap: (){
                          navigateToView(snapshot.data[position], 'View Contact');
                        },
                        child: Card(
                          elevation: 5.0,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 90.0,
                                  height: 90.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.blue,
                                    image: DecorationImage(
                                      image: snapshot.data[position].image != null
                                        ? FileImage(File(snapshot.data[position].image))
                                        : AssetImage("assets/contact/person.png"),
                                      fit: BoxFit.cover
                                    ),
                                  ),
                                ),
                                Expanded(
                                  
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15.0),
                                    
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[   
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(snapshot.data[position].name ?? "",
                                            style: TextStyle(
                                                fontSize: 28.0, fontWeight: FontWeight.bold, color: light)),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(snapshot.data[position].phone ?? "",
                                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black87 ),
                                            
                                          ),
                                        ),  
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(snapshot.data[position].email ?? "",
                                            style: TextStyle(fontSize: 17.0),overflow: TextOverflow.ellipsis,),
                                          ),
                                        
                                      ],
                                    )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
            navigateToDetail(Contact('', '', 3),'Add Contact');
          },
          tooltip: 'Add Contact',
          child: Icon(Icons.add, size: 32, color: light),
          backgroundColor: dark,
        ),
      ),
    );

  }

  void updateListView(){

    final Future<Database> dbFuture = contactHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Contact>> contactListFuture = contactHelper.getContactList();
      contactListFuture.then((contactList){
        setState(() {
          this.contactList = contactList;
          this.count = contactList.length;
        });
      });
    });
  }

  //navigate to edit page
  void navigateToDetail(Contact contact, String title) async{
   bool result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context){ return ContactDetail(contact, title);}));

    if (result == true) {
      updateListView();
    }        
  }

  //navigate to edit page
  void navigateToView(Contact contact, String title) async{
    await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context){ return ContactView(contact, title);}));
  }

}
