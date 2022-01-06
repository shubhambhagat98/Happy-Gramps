import 'dart:io';
import 'package:flutter_background/contacts_new/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_background/contacts_new/screens/contact_detail.dart';

class ContactView extends StatefulWidget{

  final String appBarTitle;
  final Contact contact;

  ContactView(this.contact, this.appBarTitle);

  @override
  State<StatefulWidget> createState(){
    return ContactViewState(this.contact, this.appBarTitle);
  }
}

class ContactViewState extends State<ContactView>{

  Color dark = Color.fromARGB(255, 37, 58, 75);
  Color light = Color.fromARGB(255,242,59,95);

  Contact contact;
  String appBarTitle;

  ContactViewState(this.contact, this.appBarTitle);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle, style: TextStyle(fontSize: 30, color: light),),
        backgroundColor: dark,
      ),
      body: SingleChildScrollView(
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //first element - image
            Padding(
              padding: EdgeInsets.only(top:10.0),
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: contact.image != null ?
                    FileImage(File(contact.image)):
                    AssetImage("assets/contact/person_icon.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            //second element name
            Padding(
              padding: EdgeInsets.only(top: 5.0, right: 15.0, left: 15.0),
              child: Card(
                elevation: 4.0,
              
                child: ListTile(
                  contentPadding: EdgeInsets.only(left:15.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: dark, size: 36),
                  ),
                  title: Text(
                    contact.name,
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: light),
                  ),
                  subtitle: Text(
                    'Name',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.grey ),
                  ),
                ),
              ),
            ),

            //third element - phone
            Padding(
              padding: EdgeInsets.only(top: 5.0, right: 15.0, left: 15.0),
              child: Card(
                elevation: 4.0,
                child: ListTile(
                  contentPadding: EdgeInsets.only(left:15.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.phone, size: 36, color: dark),
                  ),
                  title: Text(
                    contact.phone,
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: light),
                  ),
                  subtitle: Text(
                    'Phone',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.grey ),
                  ),
                ),
              ),
            ),

            //fourth element - email
            Padding(
              padding: EdgeInsets.only(top: 5.0, right: 15.0, left: 15.0),
              child: Card(
                elevation: 4.0,
                child: ListTile(
                  contentPadding: EdgeInsets.only(left:15.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.email, size: 36, color: dark),
                  ),
                  title: Text(
                    contact.email ?? "No email saved",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  subtitle: Text(
                    'Email',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.grey ),
                  ),
                ),
              ),
            ),

            //fift element - category
            Padding(
              padding: EdgeInsets.only(top: 5.0, right: 15.0, left: 15.0),
              child: Card(
                elevation: 4.0,
                child: ListTile(
                  contentPadding: EdgeInsets.only(left:15.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.category, size: 36, color: dark),
                  ),
                  title: Text(
                    getCategoryText(contact.category),
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  subtitle: Text(
                    'Category',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.grey ),
                  ),
                ),
              ),
            ),

            //last element - buttons
            Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                     children: <Widget>[
                       Expanded(
                         child: RaisedButton(
                          onPressed: (){
                            launch("tel:${contact.phone}");
                            },
                          color: light,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                                'Call',
                                style:TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,)
                              ),
                          padding: EdgeInsets.only(top: 20, bottom:20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                    
                        ),
                       ),
                       Container(width: 10.0,),
                       
                         RaisedButton(
                          onPressed: (){
                            launch("sms:${contact.phone}");
                            },
                          color: light,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                                'Message',
                                style:TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,)
                              ),
                          padding: EdgeInsets.only(top: 20, bottom:20, left: 30, right: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                    
                        ),
                      
                       Container(width: 10.0,),
                       Expanded(
                         child: RaisedButton(
                          onPressed: (){
                             navigateToDetail(this.contact, 'Edit Contact');
                             debugPrint(this.contact.name);
                            },
                          color: dark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                                'Edit',
                                style:TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,)
                              ),
                          padding: EdgeInsets.only(top: 20, bottom:20),
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
    );
  }


  //return category as text
  String getCategoryText(int category){
    switch (category) {
      case 1:
        return 'Sos';
        break;
      case 2:
        return 'Family';
        break;
      case 3:
        return 'Other';
        break;
      default:
        return 'Other';
    }
  }

  //navigate to edit page
  void navigateToDetail(Contact contact, String title) async{
    await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context){ return ContactDetail(contact, title);}));
  }

}