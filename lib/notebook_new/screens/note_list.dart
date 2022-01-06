import 'package:flutter/material.dart';
import 'package:flutter_background/notebook_new/models/note.dart';
import 'package:flutter_background/notebook_new/utils/database_helper.dart';
import 'package:flutter_background/notebook_new/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

 class NoteList extends StatefulWidget{

   @override
   State<StatefulWidget> createState(){
     return NoteListState();
   }
 }

 class NoteListState extends State<NoteList>{

   Color dark = Color.fromARGB(255, 37, 58, 75);
   Color light = Color.fromARGB(255,242,59,95);

   DatabaseHelper databaseHelper = DatabaseHelper();
   List<Note> noteList;
   int count = 0;
   int axisCount = 2;
   

   @override
   Widget build(BuildContext context){
     
     updateListView();
     if (noteList == null) {
       noteList = List<Note>(); 
       updateListView();

     }
     
     return Scaffold(
       appBar: AppBar(
         title: Text('Your Notes',
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
               child:FutureBuilder(    
                future: databaseHelper.getNoteList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                          return Text("Loading");
                    } else {
                      if (snapshot.data.length < 1) {
                            return Center(
                              child: Text(
                                'No Notes Added',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)
                                ),
                            );
                        }}
                  
                    return StaggeredGridView.countBuilder(
                      physics: BouncingScrollPhysics(),
                      crossAxisCount: 4,
                      itemCount: count,
                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical:6.0),
                      itemBuilder: (BuildContext context, int position) => GestureDetector(
                            onTap: () {
                             navigateToDetail(snapshot.data[position],'Edit Note','Edit Your Note');
                            },
                           child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Card(
                                
                                
                                elevation: 5.0,
                                color: getPriorityColor(snapshot.data[position].priority),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                             
                                              snapshot.data[position].title,
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold
                                              ),
                                             
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Text(getPriorityText(snapshot.data[position].priority),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                          )
                                        ),  
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                                snapshot.data[position].description,
                                                //style: Theme.of(context).textTheme.body2
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.normal
                                                )
                                                ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                                            child: Text(snapshot.data[position].date,
                                              style: Theme.of(context).textTheme.subtitle),
                                          ),
                                          
                                        ])
                                  ],
                                ),
                              ),
                            ),
                          ),
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    );
                },
              ) ,
             )
           ], 
         ),
       ),

   
       floatingActionButton: Container(
         height: 75,
         width: 75,
         child: FloatingActionButton(
           onPressed: (){
             debugPrint('fab clicked');
             navigateToDetail(Note('', '', 2),'Add Note','Add New Note');
           },
           backgroundColor: dark,
           tooltip: 'add note',
           child: Icon(Icons.add, color:  light, size: 32,),
          ),
       ),
     );
   }

 

  //return priority color
  Color getPriorityColor(int priority){
    switch (priority) {
      case 1:
        return Colors.redAccent[200];
        break;
      case 2:
        return Colors.amberAccent[200];
        break;
      case 3:
        return Colors.greenAccent[400];
        break;
      default:
        return Colors.greenAccent[400];
    }
  }

  //return priority icon
  Icon getPriorityIcon(int priority){
    switch (priority) {
      case 1:
        return Icon(Icons.label_important);
        break;
      case 2:
        return Icon(Icons.priority_high);
        break;
       case 3:
        return Icon(Icons.keyboard_arrow_left);
        break;
      default:
        return Icon(Icons.keyboard_arrow_left);
    }
  }

  //return priority text
  String getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return '!!!';
        break;
      case 2:
        return '!!';
        break;
      case 3:
        return '!';
        break;

      default:
        return '!';
    }
  }


 /* void _delete(BuildContext context, Note note) async{
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  } */

  void navigateToDetail(Note note, String title, String text)async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
              return NoteDetail(note, title, text);
            }));
    if (result == true) {
      updateListView();
    }        
  }

  void updateListView(){

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

 }