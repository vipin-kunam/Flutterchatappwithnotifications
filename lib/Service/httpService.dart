import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/Loader.dart' as loader;
import '../Service/mynoandbaseurl.dart';
var baseurl=getbaseurl();
Future<http.Response>  get(url) async{
  //loader.showLoaderDialog(context);
  dynamic response = await http.get(getfullurl(url)).catchError((err){
    //Navigator.pop(context);
    throw('some error');
  });
  //Navigator.pop(context);
  return response;
}
Future<http.Response>  post(url,data,context) async{
  print('in');
  loader.showLoaderDialog(context);
  dynamic response = await http.post(getfullurl(url),body: data,headers: {"Content-Type": "application/json"}).catchError((err){
    Navigator.pop(context);
    throw('some error');
  });
  print('out');
  Navigator.pop(context);
  return response;
}
Future<http.Response>  del(url) async{
  dynamic response = await http.delete(getfullurl(url));
  return response;
}
getfullurl(url){
  var fullurl=baseurl+url;
  return fullurl;
}