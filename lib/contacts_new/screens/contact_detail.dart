import 'package:flutter/material.dart';
import 'package:flutter_background/contacts_new/models/contact.dart';
import 'package:flutter_background/contacts_new/utils/contact_helper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ContactDetail extends StatefulWidget{

  final String appBarTitle;
  final Contact contact;

  ContactDetail(this.contact, this.appBarTitle);

  @override
  State<StatefulWidget> createState(){
    return ContactDetailState(this.contact, this.appBarTitle);
  }
}

class ContactDetailState extends State<ContactDetail>{

  Color dark = Color.fromARGB(255, 37, 58, 75);
  Color light = Color.fromARGB(255,242,59,95);

  static var _categories = ['Sos','Family','Other'];
  ContactHelper helper = ContactHelper();
  bool edited = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  File contactimage;

  String appBarTitle;
  Contact contact;

  ContactDetailState(this.contact, this.appBarTitle);

  @override
  Widget build(BuildContext context){
    TextStyle textStyle = Theme.of(context).textTheme.title;
    nameController.text = contact.name;
    phoneController.text = contact.phone;
    emailController.text = contact.email;
    return WillPopScope(
      onWillPop: requestPop,
      child: Scaffold(
        appBar: AppBar(
         title: Text(appBarTitle, style: TextStyle(fontSize: 30, color: light),),
         backgroundColor: dark,
         actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                  size: 30
                ),
                onPressed:(){
                          setState(() {
                            debugPrint('delete button clicked');
                            _save();
                          });
                        },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white, size: 36),
                onPressed:(){
                          setState(() {
                            debugPrint('delete button clicked');
                            _delete();
                          });
                        },
              )
            ],
        ),

        body: Padding(
          padding:EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              //First Element - image picker
              Padding(
                padding: EdgeInsets.only( bottom: 15.0),
                
                child: Center(
                  child:GestureDetector(    
                    child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      /*boxShadow: [BoxShadow(
                        color: Colors.black87,
                        blurRadius: 10.0,),],*/
                      //color: Colors.blue,
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        
                        image: contact.image != null ?
                        FileImage(File(contact.image)):
                        AssetImage("assets/contact/camera.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                    
                  onTap: (){
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          title: Text('Options to select the image:'),
                          titlePadding: EdgeInsets.all(15),
                          actions: <Widget>[
                            FlatButton.icon(
                              onPressed: () async{
                                Navigator.pop(context);
                               /* ImagePicker.pickImage(
                                   source: ImageSource.camera)
                                      .then((file) {
                                        if (file == null) return;
                                        setState(() {
                                            contact.image = file.path;
                                            edited = true;
                                          });
                                        });*/
                                 contactimage = await ImagePicker.pickImage(source: ImageSource.camera);
                                 if (contactimage == null) return;
                                  setState(() {
                                      contact.image = contactimage.path;
                                      edited = true;
                                    });

                                      },
                              icon: Icon(Icons.photo_camera,),
                              label: Text("Take photo from camera",),
                            ),

                            FlatButton.icon(
                              onPressed: () async{
                                Navigator.pop(context);
                               /* ImagePicker.pickImage(
                                   source: ImageSource.gallery)
                                      .then((file) {
                                        if (file == null) return;
                                        setState(() {
                                            contact.image = file.path;
                                            edited = true;
                                          });
                                        });*/
                                 contactimage = await ImagePicker.pickImage(source: ImageSource.gallery);
                                 if (contactimage == null) return;
                                  setState(() {
                                      contact.image = contactimage.path;
                                      edited = true;
                                    });

                                      },
                              icon: Icon(Icons.insert_photo,),
                              label: Text("Select photo from gallery", ),
                            ),
                          ],
                        ),
                      );
                  },                               
                ),
                ),
                
              ),

              //Second Element - name
              Padding(
                padding: EdgeInsets.only( bottom: 10.0),
                child: TextField(
                  maxLength: 255,
                  controller: nameController,
                  style: textStyle,
                  onChanged: (value){
                    edited = true;
                    debugPrint('something changed in txt field');
                    updateName();
                  },
                  decoration: InputDecoration(
                    //fillColor: Colors.grey.shade300,
                    //filled: true,
                    labelText: 'Name',
                    labelStyle: TextStyle(fontSize: 24, color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                ),
              ),

              //third element - phone
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  maxLength: 13,
                  controller: phoneController,
                  style: textStyle,
                  keyboardType: TextInputType.number,
                  onChanged: (value){
                    edited = true;
                    debugPrint('something changed in txt field');
                    updatePhone();
                  },
                  decoration: InputDecoration(
                    //fillColor: Colors.grey.shade300,
                    //filled: true,
                    labelText: 'Phone',
                    labelStyle: TextStyle(fontSize: 24, color: Colors.grey[700]),
                    hintText: 'Enter without +91',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                ),
              ),

              //fourth element - email
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: TextField(
                  maxLength: 255,
                  controller: emailController,
                  style: textStyle,
                  onChanged: (value){
                    edited = true;
                    debugPrint('something changed in txt field');
                    updateEmail();
                  },
                  decoration: InputDecoration(
                    //fillColor: Colors.grey.shade300,
                    //filled: true,
                    labelText: 'Email Address',
                    labelStyle: TextStyle(fontSize: 24, color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                ),
              ),

              //fifth element - dropdown category
              Padding(
                 padding: EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
                child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                leading: Text("Select category:",style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.black87) ),
                title: DropdownButton(
                  items: _categories.map((String dropDownStringItem){
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem, style: TextStyle(fontSize: 22),),
                    );
                  }).toList(),
                  style:Theme.of(context).textTheme.body1,
                  value: getCategoryAsString(contact.category),
                
                 onChanged: (valueSelected){
                    setState(() {
                      debugPrint('user selected $valueSelected');
                      updateCategoryAsInt(valueSelected);
                    });
                  },
                  
                ),
                
              ),
              ),

              //last ement - button
              Padding(
                padding: EdgeInsets.only( top:10.0,bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                        color: dark,
                        textColor: Theme.of(context).primaryColorLight,
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
                        textColor: Theme.of(context).primaryColorLight,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  //convert string category to integer before saving it in database
    void updateCategoryAsInt(String value){
      switch (value) {
      case 'Sos':
        contact.category = 1;
        break;
      case 'Family':
        contact.category = 2;
        break;
      case 'Other':
        contact.category = 3;
        break;
      }
    }

    //covert int category to string before saving it in database and display it to user
    String getCategoryAsString(int value){
      String category;
      switch (value) {
        case 1:
          category = _categories[0]; //sos
          break;
        case 2:
          category = _categories[1]; //family
          break;
        case 3:
          category = _categories[2]; //other
          break;
      }
      return category;
    }

    //update name of contact object
    void updateName(){
      contact.name = nameController.text;
    }

    //update phone of contact object
    void updatePhone(){
      contact.phone = phoneController.text;
    }

    //update email of contact object
    void updateEmail(){
      contact.email = emailController.text;
    }

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
              //     MaterialPageRoute(builder: (context) => ContactList()),
              //     (Route<dynamic> route) => false,);
                Navigator.pop(context);
                Navigator.pop(context);//view page
                Navigator.pop(context);//list page
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

  //save data to database

  void _save() async{

    int result;

    String phonePattern = r'(^(?:[+0]9)?[0-9]{8,12}$)';
    RegExp regExpPhone = new RegExp(phonePattern);

    String emailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExpEmail = new RegExp(emailPattern);

    String name = nameController.text;
    String phone = phoneController.text;
    String email = emailController.text;

    if (name.isEmpty){
       _showAlertDialog('Oops...','Name cannot be empty!');
    } else if (phone.isEmpty){
       _showAlertDialog('Oops...','phone cannot be empty!');
    } else if(!regExpPhone.hasMatch(phone)){
       _showAlertDialog('Oops...','Please enter a valid phone number!');
    } else if(!regExpEmail.hasMatch(email) && email.isNotEmpty){
       _showAlertDialog('Oops...','Please enter a valid email address!');
    } else if(!regExpPhone.hasMatch(phone) && !regExpEmail.hasMatch(email)){
       _showAlertDialog('Oops...','Please enter a valid phone number and email address!');
    } else{
      if (contact.id != null) { //update
        result = await helper.updateContact(contact);
      } else {
        result = await helper.insertContact(contact);
      }

    
      Navigator.pop(context, true);

      if (result != 0) {//success
        _showAlertDialog('Status','Contact Saved Successfully');
      } else {//failure
          _showAlertDialog('Status','Problem Saving the Note');
      }

    }
  }

  //delete contact
  void _delete() async {

    if (contact.id == null) { //case 1: delete new note
      Navigator.pop(context, true);
      _showAlertDialog('Status', 'No Contact was Deleted');
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context, ) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text('Delete Contact'),
            content: Text("Are you sure, you want to delete this contact?", style: Theme.of(context).textTheme.subhead),
            actions: <Widget>[
              RawMaterialButton(
                onPressed: () async {
                  helper.deleteContact(contact.id);  
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  
                  _showAlertDialog('Status','Contact deleted Successfully');
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




}