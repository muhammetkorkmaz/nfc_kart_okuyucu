
import 'dart:convert';
import 'package:flutter_app/NotificationPlugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MaterialApp(
  home: LocalNotifications()//Home()
));

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "data",
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lime[600],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(onPressed: (){
              //f._insert();
            },
            child: Text("Insert"),color: Colors.red),
            FlatButton(onPressed: () {
              //f._get_kart();
            }, child: Text("GetKart"),color: Colors.lightBlue),
            FlatButton(onPressed: () {
              //f._bakiyedus();
            }, child: Text("Bakiye Düş"),color: Colors.black26),
            FlatButton(onPressed: () {

            }, child: Text("Bildirim"),color: Colors.amber),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("+"),
        backgroundColor: Colors.lime[600],
      ),
    );

  }

}



