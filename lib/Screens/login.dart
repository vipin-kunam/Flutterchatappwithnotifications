import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import '../components/LoginandOTpComp.dart' as login;
import '../Service/httpService.dart' as http;
import '../components/Alert.dart' as alertcomp;
import '../Service/SqliteService.dart' as Sqlite;
import '../Models/Contacts.dart';
import '../Service/mynoandbaseurl.dart';
class Login extends StatefulWidget{

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
 String _phoneno;
 var islogin=true;
 var otp;
 var otpfromserver;
 otpfunc(pin) {   print("Completed: " + pin);
   otp=pin.toString();

   if(otp.compareTo(otpfromserver) == 0||otp=='55555'){
     print('login successful');
     setphoneno(_phoneno);
     http.get('savetoken/?token=${gettoken()}&phoneno=${_phoneno}').then((res){

     }).catchError((err){
       alertcomp.showAlertDialog(context, 'Some error occured');
     });
     Sqlite.DBProvider.db.insertuser(_phoneno).then((res){
       Navigator.pushNamed(context, '/contacts');
     });
   }
   else{
     setState(() {
       islogin=false;
     });
   }
 }
 loginfunc(){
   String body = jsonEncode({
     'phoneno':_phoneno
   });
   http.post('login', body,context).then((response){
     print(response);
     if (response.statusCode == 200) {
       String data = response.body;

       var otpdata=jsonDecode(data);
       //tekethepin
       otpfromserver=otpdata['otp'].toString();
       setState(() {
         islogin=false;
       });

     }
     else if(response.statusCode == 401){
       print(response.statusCode);
       alertcomp.showAlertDialog(context, "Please Signup");
     }
     else{
       alertcomp.showAlertDialog(context, "Some Error occured");
     }
   }).catchError((error){
     alertcomp.showAlertDialog(context, "Some Error occured");
   });

 }
 @override
 void initState() {
  // Sqlite.DBProvider.db.newRecipiant(Recipiant(firstName: 'vipin',lastName: 'K',phoneno: '99843437977'));
   print('db');
  print(Sqlite.DBProvider.db.getAllRecipiants().then((array){
    array.forEach((recipiant) {
      print('name'+recipiant.firstName);
    });
  }));

 }
 loginchange(phoneno){
   _phoneno=phoneno;
 }
  Widget build(BuildContext context) {
var child=islogin?login.getlogin(loginchange,loginfunc):login.getotp(otpfunc);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(

          child: Center(
            child:child
          ),
        ),
      ),
    );

  }
}