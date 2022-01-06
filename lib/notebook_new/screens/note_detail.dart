import 'package:flutter/material.dart';
import 'package:flutter_background/notebook_new/models/note.dart';
import 'package:flutter_background/notebook_new/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget{
  final String appBarTitle;
  final Note note;
  final String displayText;

  /*NoteDetail(note, title, text){
    this.note=note;
    this.appBarTitle=title;
    this.displayText=text;
  }*/

  NoteDetail(this.note,this.appBarTitle,this.displayText);

  @override
  State<StatefulWidget> createState(){
    return NoteDetailState(this.note, this.appBarTitle, this.displayText);

  //NoteDetailState createState() => new NoteDetailState();  
  }
}

class NoteDetailState extends State<NoteDetail>{

  Color dark = Color.fromARGB(255, 37, 58, 75);
  Color light = Color.fromARGB(255,242,59,95);

  static var _priorities = ['High','Medium','Low'];
  DatabaseHelper helper = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String appBarTitle;
  Note note;
  String displayText;
  bool edited = false;
 
  /*NoteDetailState(title, text){
    this.appBarTitle=title;
    this.displayText=text;
  }*/
  NoteDetailState(this.note, this.appBarTitle, this.displayText);

  @override
  Widget build(BuildContext context){
    TextStyle textStyle = Theme.of(context).textTheme.title;
    
    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
      onWillPop: requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle,
            style: TextStyle(
              fontSize: 30,
              color: light,
            ),
          ),
          backgroundColor: dark,
          actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                    size: 36
                  ),
                  onPressed:(){
                            setState(() {
                              debugPrint('save button clicked');
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

        body: 
        
        Padding(
          padding:EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
          


          child: ListView(
            
            
            children: <Widget>[
              /* Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Center(
                
                  child: Text(displayText, style: textStyle,),
                
              ),
              ),*/
                //First element
                Padding(
                  
                  padding: EdgeInsets.only(top: 15.0, bottom: 10.0,),
                  child:   ListTile(
                  leading: Text("Select Priority Level:",style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.black87) ),
                  title: DropdownButton(
                    items: _priorities.map((String dropDownStringItem){
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    style:  TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.black87),
                    value: getPriorityAsString(note.priority),
                  onChanged: (valueSelected){
                      setState(() {
                        debugPrint('user selected $valueSelected');
                        updatePriorityAsInt(valueSelected);
                      });
                    },
                    
                  ),
                ),
                ),
              

                //Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    maxLength: 255,
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value){
                      edited = true;
                      debugPrint('something changed in txt field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      //fillColor: Colors.grey.shade300,
                      //filled: true,
                      labelText: 'Title',
                      labelStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700]
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
                  ),
                ),

              //Third Element
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: TextField(
                    
                    maxLines: 10,
                    maxLength: 255,
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value){
                      edited = true;
                      debugPrint('something changed in description txt field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                    
                      //fillColor: Colors.grey.shade300,
                      //filled: true,
                      labelText: 'Description',
                      labelStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700]
                      ),
                      hintStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      
                      )
                    ),
                    
                  ),
                ),

                //fourth element
              Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
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
                ),
            ],
          ),
        
        ),
      ),
    );
  }

  //convert string priority to integer before saving it in database
  void updatePriorityAsInt(String value){
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Medium':
        note.priority = 2;
        break;
      case 'Low':
        note.priority = 3;
        break;
    }
  }

  //convert int priority to string before saving it in database and Display it to user in dropdown
  String getPriorityAsString(int value){
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];//high
        break;
      case 2:
        priority = _priorities[1];//medium
        break;
      case 3:
        priority = _priorities[2];//low
        break;
    }
    return priority;
  }

  //update title of note object
  void updateTitle(){
    note.title = titleController.text;
  }

  //update description of note object
  void updateDescription(){
    note.description = descriptionController.text;
  }




  //save data to database
  void _save() async{

    
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;

    if (titleController.text.isEmpty) {
      _showAlertDialog('Oops...','Title cannot be empty!');
    } else if(descriptionController.text.isEmpty) {
      _showAlertDialog('Oops...','Description cannot be empty!');
    }else{
      if (note.id != null) { //case 1:update
        result = await helper.updateNote(note);
        } else {//case 2: insert
          result = await helper.insertNote(note);
        }   
      Navigator.pop(context, true);


      // Navigator.pushAndRemoveUntil(
      //                             context, 
      //                             MaterialPageRoute(builder: (context,) => NoteList()),
      //                             (Route<dynamic> route) => false);
      if (result != 0) {//success
      _showAlertDialog('Status','Note Saved Successfully');
      } else {//failure
        _showAlertDialog('Status','Problem Saving the Note');
      }
    }


     /* if (note.id != null) { //case 1:update
      result = await helper.updateNote(note);
      } else {//case 2: insert
        result = await helper.insertNote(note);
      }
  
    
      Navigator.pop(context, true);*/
    

    
  }

  void _delete() async {

    //Navigator.pop(context, true);

    if (note.id == null) { //case 1: delete new note
      _showAlertDialog('Status', 'No Note was Deleted');
      return;
    }

    
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text("Are you sure, you want to delete this Note?", style: Theme.of(context).textTheme.body1),
            actions: <Widget>[
              RawMaterialButton(
                onPressed: () async {
                  await helper.deleteNote(note.id);
                
                  Navigator.pop(context);
                  Navigator.pop(context);
                 
              
                      _showAlertDialog('Status','Note deleted Successfully');
                },
                child: Text("Yes",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              ),
              RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              )
            ],
          );
        });
  }

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
              //     MaterialPageRoute(builder: (context) => NoteList()),
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
 

  void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }
}

