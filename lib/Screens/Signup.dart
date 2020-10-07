import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../Models/userinfo.dart';
import '../Service/httpService.dart' as http;
import 'dart:convert';
import '../components/Alert.dart' as alertcomp;
class Signup extends  StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String _username,_email,_phoneno;

  final _formKey = GlobalKey<FormState>();

  sendtoserver(){
    var payload=userinfo(_username,_email,_phoneno);
    String body = jsonEncode({
      'uname':payload.uname,
      'email':payload.email,
      'phoneno':payload.phoneno
    });
    http.post('signup', body,context).then((response){
    if (response.statusCode == 201) {
        String data = response.body;
        Navigator.pushNamed(context, '/');
         print(jsonDecode(data));
  }
    else if(response.statusCode == 409){
    print(response.statusCode);
    alertcomp.showAlertDialog(context, "User already exist");
    }
    else{
      alertcomp.showAlertDialog(context, "Some Error occured");
    }
    }).catchError((error){
      alertcomp.showAlertDialog(context, "Some Error occured");
    });
  }

  Widget build(BuildContext context) {



    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ChatApp'),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        validator: (name){
                          Pattern pattern =
                              r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                          RegExp regex = new RegExp(pattern);
                          if (!regex.hasMatch(name))
                            return 'Invalid username';
                          else
                            return null;

                        },
                        onSaved: (name)=> _username = name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'User Name',
                          hintText: 'Enter Your Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (email)=>EmailValidator.validate(email)? null:"Invalid email address",
                        onSaved: (email)=> _email = email,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Enter Email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (phno){
                          if (phno.length==10)
                            return null;
                          else
                            return 'Enter Valid Phone Number';
                        },
                        onSaved: (phno)=> _phoneno = phno,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone',
                          hintText: 'Enter Phone number',
                        ),
                      ),
                    ),
                    RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Signup'),
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          _formKey.currentState.save();
                         sendtoserver();
                        }
                      },
                    )
                  ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
