import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
var accessbutton;
getaccessedbutton(handler)=>{
 accessbutton= <Widget>[Container(
  child: RaisedButton(
   child: Text('Give access'),
   onPressed: ()=>{handler()},
  ),
 )
]
};
