import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import './components/welcome.dart' as welcome;
import 'package:flutter/cupertino.dart';
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
   PermissionStatus _permissionStatus;
   var comp;
   Future <void> checkpermission()async{
     _permissionStatus = await getPermission();

   }
   @override
   void initState() {
    super.initState();
    //comp=welcome.getwelcome(checkpermissionbeforeloginandthenroute);
    checkpermission();
   }
Future<PermissionStatus> getPermission() async {
     final PermissionStatus permission = await Permission.contacts.status;
     if (permission != PermissionStatus.granted &&
         permission != PermissionStatus.denied) {
       final Map<Permission, PermissionStatus> permissionStatus =
       await [Permission.contacts].request();
       return permissionStatus[Permission.contacts] ??
           PermissionStatus.undetermined;
     } else {
       return permission;
     }
   }
   checkpermissionbeforeloginandthenroute(){

   if (_permissionStatus == PermissionStatus.granted) {
   //We can now access our contacts here
   Navigator.pushNamed(context, '/login');
   print('status');
   print(_permissionStatus);
}
   else{
//setState(() {
//comp=grant.getaccessedbutton(checkpermission);
//});
     showDialog(
         context: context,
         builder: (BuildContext context) => CupertinoAlertDialog(
           title: Text('Permissions error'),
           content: Text('Please enable contacts access '
               'permission in system settings'),
           actions: <Widget>[
             CupertinoDialogAction(
               child: Text('OK'),
               onPressed: () => Navigator.of(context).pop(),
             )
           ],
         ));


   }

   }

  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ChatApp'),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:welcome.getwelcome(checkpermissionbeforeloginandthenroute,context)
            ),
        ),
      ),
    );
  }
}
