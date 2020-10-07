import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:testing_app/Service/mynoandbaseurl.dart';
import './Permission.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Service/httpService.dart' as http;
import '../components/Alert.dart' as alertcomp;
import '../Service/SqliteService.dart' as Sqlite;
import '../Models/Contacts.dart';
import '../Service/Socketservice.dart';
import 'package:flutter/services.dart';
import '../components/Alert.dart' as alert;
class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<dynamic> _contacts;
  var noofmessage={};
  var showloader=false;
  IO.Socket socket;
  var _contactsfromserver;
   PermissionStatus permissionStatus;
  void dispose() {
    socket.dispose();
    super.dispose();
  }
  getcount(){
    var myphoneno = getphoneno();
    var myphoneno1=myphoneno.substring(myphoneno.length - 10);
    showloader=true;
    http.get('contacts/getall/?to=${myphoneno1}').then((response){
      print('res ${response.body}');

      setState(() {
        noofmessage=jsonDecode(response.body);
        showloader=false;
      });
    }).catchError((error){
      showloader=false;
      alert.showAlertDialog(context, 'Some Error Occured');
    });
  }
  @override
  void initState() {
    super.initState();
    getcount();
    var myphoneno = getphoneno();
    var myphoneno1=myphoneno.substring(myphoneno.length - 10);
     socket = getnewsocket();
    print('listening');
    socket.on('connect', (_) {
    });
    socket.on('connect_error', (err) {
      print('errorconecting');
      print(err);
    });
    socket.on(myphoneno1,(data){
      try{
        if(ModalRoute.of(context).settings.name=='/contacts'){
          getcount();
        }
      }
      catch(e){

      }

    });
Sqlite.DBProvider.db.getAllRecipiants().then((response){
  if(!response.isEmpty){
    print(response[0].firstName);
    setState(() {
      _contacts = response;
    });
  }
  else{
    getContacts();
  }

});


  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
  List<dynamic> toservercontacts =new List();
  contacts.forEach((element) {
    toservercontacts.add(element.toMap());
  });
  http.post('contacts/check',jsonEncode(toservercontacts),context).then((response){
    //print(jsonDecode(response.body));

    _contactsfromserver=jsonDecode(response.body);
print('got response');
    Sqlite.DBProvider.db.deleteAll().then((res){
      print('afterdelte');
      _contactsfromserver.forEach((element) {
        print(element['phoneno']);
        Recipiant r=Recipiant(blocked: false,firstName: element['displayName'],lastName: element['familyName'],phoneno: element['phoneno']);
        Sqlite.DBProvider.db.newRecipiant(r).then((res){
          if(_contactsfromserver.last==element){
            List <dynamic> temp;
            Sqlite.DBProvider.db.getAllRecipiants().then((response){
             var myphoneno = getphoneno();
             var myphoneno1=myphoneno.substring(myphoneno.length - 10);
             print('res len ${response.length}');
             if(response.length>0){
var index=response.indexWhere((e)=>e.phoneno.substring(e.phoneno.length - 10)==myphoneno1);//.where((e)=>e.phoneno.substring(e.phoneno.length - 10)!=myphoneno1);
if(index>-1){
response.removeAt(index);}}
              temp=response;
              setState(() {
                _contacts = response;
              });
            });
          }
        });

      });


    });

  }).catchError((error){
    print(error);
    alertcomp.showAlertDialog(context, "Some Error occured");
  });


  }
  Future<bool> _onWillPop() async {
    //Navigator.pop(context);
    SystemNavigator.pop();
    //alert.showAlertDialog(context, 'Backbutton  Disabled');
  }
  checkformessages(contact){
  for(var key in noofmessage.keys){
    if(key==contact.phoneno.substring(contact.phoneno.length-10)){
      //key=key+'m';
      var listile= ListTile(leading: Icon(Icons.chat),trailing: Badge(
        badgeColor: Colors.green,
        shape: BadgeShape.circle,
        toAnimate: false,
        badgeContent:
        Text(noofmessage[key].toString(), style: TextStyle(color: Colors.white)),
      ),title:  Text(contact.firstName));
      //key=key+'m';
      return listile;
    }
  }
  return ListTile(leading: Icon(Icons.chat),title:  Text(contact.firstName));
}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop:_onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: (Text('Contacts')),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )
            ),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onLongPress: () {

                      setState(() {
                        _contacts=null;
                      });
                      HapticFeedback.mediumImpact();
                      getContacts();
                  },
                  child: Icon(
                      Icons.refresh
                  ),
                )
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: _contacts != null&&!showloader
        //Build a list view of all contacts, displaying their avatar and
        // display name
            ? ListView.separated(itemCount:_contacts.length ,
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            itemBuilder: (BuildContext ctxt, int index) {
          return FlatButton(child:checkformessages(_contacts[index]) ,onPressed: (){
            setsenderno(_contacts[index].phoneno);
            setsendermsg(_contacts[index].firstName);
            getcountofcontacts=getcount;
            Navigator.pushNamed(context, '/chat',arguments: _contacts[index].phoneno);

          },);
        })
            : Center(child: const CircularProgressIndicator()),
      ),
    );


  }
}
