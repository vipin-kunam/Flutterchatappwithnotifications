import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
var login;
var OTP;
getlogin(handler,handler2){
  login=Column(
    children:<Widget>[Padding(
      padding: EdgeInsets.all(15),
      child: TextField(
        autofocus: true,
        keyboardType: TextInputType.number,
        onChanged:handler ,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Phone',
          hintText: 'Enter Phone number',
        ),
      ),
    ),
      Text('Enter Your Phone number',
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 20),)
      ,RaisedButton(
        child: Text('Login'),
        onPressed: handler2,
      )
    ],
  );
return login;
}
getotp(handler){
  OTP= Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children:<Widget>[ Row(
        children:<Widget>[ Expanded(
          flex: 5,
          child: OTPTextField(
            length: 5,
            fieldStyle: FieldStyle.underline,
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldWidth: 20,

            style: TextStyle(
                fontSize: 17
            ),
            onCompleted:handler,
          ),
        ),
       ]
    ),
    Padding(
       padding: EdgeInsets.all(15),
        child: Text('Enter otp')),
    RaisedButton(
      child: Text('Enter number again'),
    )]
  );
  return OTP;
}