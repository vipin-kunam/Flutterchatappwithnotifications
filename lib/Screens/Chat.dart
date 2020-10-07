import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:bubble/bubble.dart';
import '../components/Alert.dart' as alertcomp;
import '../Service/mynoandbaseurl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../Service/Socketservice.dart';
import '../Service/SqliteService.dart' as Sqlite;
import 'package:flutter/services.dart';
import '../Service/httpService.dart' as http;
class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var chatString='';
  var map;
  var myphoneno ;
  var myphoneno1;
  var phoneno ;
  var phoneno1;
  var tobedeletedid=[];
  var showdeleicon=false;
  List<dynamic> _chatsfromserver;
  ScrollController _controller = new ScrollController();
  IO.Socket socket;
  List<dynamic> litems = [];
  List<dynamic> litemsfromserver = [];
  var sendtextholer=TextEditingController();
  var listening;
  var showloader=false;
  sendmessage(){
    if(chatString.trim()=="")
      return;
    var details ={
      'chatString':chatString,
      'listening':listening,
      'from':myphoneno1,
      'to':phoneno1
    };
    socket.emit('fromclient', details);
    chatString='';
  }
  receivemessage(map){

  }
  getdatafromsqlite(){
    Sqlite.DBProvider.db.getAllMessages(myphoneno1,phoneno1).then((response){
      print(response);
      setState(() {
        litems=response;
        showloader=false;
      });
      Timer(
          Duration(milliseconds: 100),
              () => _controller
              .jumpTo(_controller.position.maxScrollExtent));

    });
  }
  @override
  void dispose() {
   socket.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();

     myphoneno = getphoneno();
     myphoneno1=myphoneno.substring(myphoneno.length - 10);
     phoneno = getsenderno();
     phoneno1=phoneno.substring(phoneno.length - 10);
    List<String> s=[myphoneno1,phoneno1];
    s.sort();
    listening=s.join();
    setState(() {
      showloader=true;
    });
    http.get('contacts/getanddelete/?from=${phoneno1}&to=${myphoneno1}').then((response)async  {

      _chatsfromserver =jsonDecode(response.body);
      if(_chatsfromserver.isEmpty){
        getdatafromsqlite();
      }
      else{
      for(dynamic data in _chatsfromserver){
         await Sqlite.DBProvider.db.insertmessage(data['chatString'], data['from'], data['to']);
      }
      getdatafromsqlite();}
      getcountofcontacts();
    }).catchError((error){
      print(error);
      setState(() {
        showloader=false;
      });
      alertcomp.showAlertDialog(context, "Some Error occured");
    });

    socket = getnewsocket();
    socket.on(listening, (data){
      print(data);
      if(data['to']==myphoneno1){
        var payload={'id':data['id']};
        socket.emit('ack', payload);
      }
     Sqlite.DBProvider.db.insertmessage(data['chatString'], data['from'], data['to']).then((id){
      Sqlite.DBProvider.db.getmessagebyid(id).then((res){
        print(res);
       litems.add(res[0]);
        setState(() {

        });
       HapticFeedback.mediumImpact();
       Timer(
            Duration(milliseconds: 100),
                () => _controller
                .jumpTo(_controller.position.maxScrollExtent));
      });


     });
    });
  }
  updateuiondelete(){
    var temparr=[...litems];
    var toberemoved=[];
    if(tobedeletedid.length>0){
      for(var id in tobedeletedid){
      for(var x in temparr){
       if(id==x['id']){
         toberemoved.add(x);
       }
      }
      }
      toberemoved.forEach((e) {
        temparr.remove(e);
      });
      tobedeletedid=[];
      setState(() {
        litems=temparr;
        showdeleicon=tobedeletedid.length>0?true:false;
      });
    }

  }
  deletemessages()async{
    if(tobedeletedid.length>0){
      for(var id in tobedeletedid){
        await Sqlite.DBProvider.db.deletemessagebyid(id);
      }
    }
    updateuiondelete();
  }

  selectrunselect(index,id){
if(tobedeletedid.contains(id)){
  tobedeletedid.remove(id);
 Map temp= {...litems[index]};
 temp['selected']=0;
  litems[index]=temp;
}
else{
  tobedeletedid.add(id);
  Map temp= {...litems[index]};
  temp['selected']=1;
  litems[index]=temp;
}
setState(() {
  showdeleicon=tobedeletedid.length>0?true:false;
});

  }

  Widget build(BuildContext context) {
var chater=getsendermsg();

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () =>  Navigator.pop(context),
              ),
            title: Text(chater),
            actions: <Widget>[Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: showdeleicon?GestureDetector(
                  onTap: () {
                    deletemessages();
                  },
                  child: Icon(
                    Icons.delete,
                    size: 26.0,
                  ),
                ):Text('')
            ),],
          ),
          body: showloader?Center(child: const CircularProgressIndicator()):Container(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: ListView.builder(
                        controller: _controller,
                          itemCount: litems.length,
                          itemBuilder: (BuildContext ctxt, int Index) {
                            return GestureDetector(
                              onLongPress: (){
                                selectrunselect(Index,litems[Index]['id']);
                                HapticFeedback.heavyImpact();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.50,
                                  height: 40,
                                  color:litems[Index]['selected']==0?Colors.transparent:Colors.black12,
                                  child: Bubble(
                                    nip:myphoneno1==litems[Index]['sender']? BubbleNip.rightTop:BubbleNip.leftTop,
                                    alignment: myphoneno1==litems[Index]['sender']?Alignment.topRight:Alignment.topLeft,
                                    margin: BubbleEdges.only(top: 10),
                                    color: myphoneno1==litems[Index]['sender']?Color.fromRGBO(225, 255, 199, 1.0):Color.fromRGBO(212, 234, 244, 1.0),
                                    child:
                                        Text(litems[Index]['message'], textAlign: TextAlign.right),
                                  ),
                                ),
                              ),
                            );
                          })),
                  Container(
                    color:Colors.transparent ,
                    constraints:BoxConstraints(
                      minHeight: 50.0,
                      maxHeight: 80.0,
                    ),
                    child: Row(
                        children: <Widget>[
                      Expanded(
                        child: TextFormField(
maxLines: 1,
                          controller: sendtextholer,
                          onChanged: (value){
                            chatString=value;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Send Message',
                          ),
                        ),
                      ),
              Padding(
                padding: EdgeInsets.only(left: 3),
                child: InkWell(
                  onTap: (){
                    HapticFeedback.mediumImpact();
                    sendtextholer.clear();
                    sendmessage();
                  },
                  child: Container(
                    height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.blue,

                      ),

                      child: Icon(Icons.send)),
                ),
              )
                    ]),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
