import 'package:flutter/material.dart';
var welcome;
getwelcome(handler,context){
  welcome=<Widget>[
    Row(
      children:<Widget>[ Expanded(
        child: Container(
            child:Center(
                child: Text('Welcome',
                  style:TextStyle(fontSize: 30.0),)
            )
        ),
      )],
    ),
    SizedBox(height: 10),
    Row(children: <Widget>[
      Expanded(
        child: Container(
          height: 35,
          child: Padding(
               padding: EdgeInsets.symmetric(horizontal: 15),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blueAccent)),
              child: Text(
                'Signup',
                style: TextStyle(fontSize: 20.0),
              ),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
            ),
          ),
        ),
      ),
    ]),
    SizedBox(height: 10),
    Row(children: <Widget>[
      Expanded(
        child: Container(
          height: 35,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
            child: RaisedButton(
              shape: RoundedRectangleBorder(

                  side: BorderSide(color: Colors.red)),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 20.0),
              ),
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                handler();
              },
            ),
          ),
        ),
      ),
    ]),
  ];
  return welcome;
}