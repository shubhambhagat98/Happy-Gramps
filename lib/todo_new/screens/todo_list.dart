import 'package:flutter/material.dart';
import 'package:flutter_background/todo_new/screens/new_task.dart';
import 'dart:async';
import 'package:flutter_background/todo_new/model/task.dart';
import 'package:flutter_background/todo_new/util/todo_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_background/todo_new/custom_widget/custom_widget.dart';


Color dark = Color.fromARGB(255, 37, 58, 75);
Color light = Color.fromARGB(255, 242, 59, 95);


class TodoList extends StatefulWidget {
  

  @override
  State<StatefulWidget> createState() {
    return TodoState();
  }
}

class TodoState extends State<TodoList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Task> taskList;
  int count = 0;
  final homeScaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    if (taskList == null) {
      taskList = List<Task>();
      updateListView();
    }

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          key: homeScaffold,
          appBar: AppBar(
            backgroundColor: dark,
            title: Text(
              'Your Tasks',
              style: TextStyle(fontSize: 30, color: light),
            ),

            bottom: TabBar(tabs: [
              Tab(
                icon: Icon(Icons.format_list_numbered_rtl, size: 30),
              ),
              Tab(
                icon: Icon(Icons.playlist_add_check, size: 30),
              ),
            ],
            indicatorColor: light,
            indicatorWeight: 5.0 ),
          ), //AppBar
          body: TabBarView(
            children: [
            new Container(
              padding: EdgeInsets.all(15.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: FutureBuilder(
                      future: databaseHelper.getInCompleteTaskList(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Text("Loading");
                        } else {
                          if (snapshot.data.length < 1) {
                            return Center(
                              child: Text(
                                'No Tasks Added',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder:
                                  (BuildContext context, int position) {
                                return new GestureDetector(
                                    onTap: () {
                                      if (snapshot.data[position].status !=
                                          "Task Completed")
                                        navigateToTask(snapshot.data[position],
                                            "Edit Task", this);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Card(
                                        margin: EdgeInsets.only(bottom: 5.0),
                                        elevation: 2.0,
                                        child: CustomWidget(
                                          title: snapshot.data[position].task,
                                          sub1: snapshot.data[position].date,
                                          sub2: snapshot.data[position].time,
                                          status: snapshot.data[position].status,
                                          delete:
                                            snapshot.data[position].status ==
                                                      "Task Completed"
                                                  ? IconButton(
                                                      icon: Icon(Icons.delete, size: 36, color: Colors.blue),
                                                      onPressed: null,
                                                    )
                                                  : Container(),
                                          trailing: Icon(
                                            Icons.edit,
                                            color: light,
                                            size: 36,
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    );
                                    
                              }
                              );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),//Container
            new Container(
              padding: EdgeInsets.all(15.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: FutureBuilder(
                      future: databaseHelper.getCompleteTaskList(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Text("Loading");
                        } else {
                          if (snapshot.data.length < 1) {
                            return Center(
                              child: Text(
                                'No Tasks Completed',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder:
                                  (BuildContext context, int position) {
                                return new GestureDetector(
                                    onTap: () {
                                      if (snapshot.data[position].status !=
                                          "Task Completed")
                                        navigateToTask(snapshot.data[position],
                                            "Edit Task", this);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Card(
                                        margin: EdgeInsets.all(1.0),
                                        elevation: 2.0,
                                        child: CustomWidget(
                                          title: snapshot.data[position].task,
                                          sub1: snapshot.data[position].date,
                                          sub2: snapshot.data[position].time,
                                          status: snapshot.data[position].status,
                                          delete:
                                          snapshot.data[position].status ==
                                              "Task Completed"
                                              ? IconButton(
                                            icon: Icon(Icons.delete,
                                            color: Colors.red[700],
                                            size: 36),
                                            onPressed: (){
                                              delete(snapshot.data[position].id);
                                            },
                                          )
                                              : Container(),
                                          trailing: Container()
//                                    Icon(
//                                          Icons.edit,
//                                          color: Theme.of(context).primaryColor,
//                                          size: 28,
//                                        ),
                                        ),
                                      ),
                                    ) //Card
                                );
                              });
                        }
                      },
                    ),
                  )
                ],
              ),
            ),//Container
          ]

          ),
          floatingActionButton: Container(
            height: 75,
            width: 75,
            child: FloatingActionButton(
              backgroundColor: dark,
                tooltip: "Add Task",
                child: Icon(Icons.add, color: light, size: 32),
                onPressed: () {
                  navigateToTask(Task('', '', '', '', '', '', ''), "Add Task", this);
                }),
          ), //FloatingActionButton
        ));
  } //build()


  void navigateToTask(Task task, String title, TodoState obj) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewTask(task, title, obj)),
    );
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();

    dbFuture.then((database) {
      Future<List<Task>> taskListFuture = databaseHelper.getTaskList();
      taskListFuture.then((taskList) {
        setState(() {
          this.taskList = taskList;
          this.count = taskList.length;
        });
      });
    });
  } //updateListView()

  void delete(int id) async {
      await databaseHelper.deleteTask(id);
      updateListView();
      //Navigator.pop(context);
    showAlertDialog(context, 'Status', 'Task Deleted Sucessfully');
  }

  void showSnackBar(var scaffoldkey, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1, milliseconds: 500),
    );
    scaffoldkey.currentState.showSnackBar(snackBar);
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
