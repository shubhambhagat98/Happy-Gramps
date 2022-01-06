import 'package:flutter/material.dart';

Color dark = Color.fromARGB(255, 37, 58, 75);
Color light = Color.fromARGB(255, 242, 59, 95);

class CustomWidget extends StatelessWidget {
  CustomWidget({
    Key key,
    this.title,
    this.sub1,
    this.sub2,
    this.delete,
    this.trailing,
    this.status,
  }) : super(key: key);

  final String title;
  final String sub1;
  final String sub2;
  final Widget delete;
  final Widget trailing;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: <Widget>[
                  Text(
                    '$title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 28,
                      color: dark,
                      fontWeight: FontWeight.bold,
                    ),
                  ), //Text

                  const Padding(padding: EdgeInsets.only(bottom: 10.0)),

                  Text(
                    '$sub1 · $sub2',
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'Lato',
                        //fontStyle: FontStyle.italic,
                        //fontWeight: FontWeight.bold,
                        color: Color.fromARGB(200, 37, 58, 75),
                        fontSize: 20),
                  ),

                  Text(
                    '$status',
                    style: TextStyle( fontFamily: 'Lato',
                        fontStyle: FontStyle.italic,
                        color: light,fontSize: 15),
                  ), //Text

                ],
              ),
            ), //Column
          ),
          delete,
          trailing,
        ]));
  } //build()

}
