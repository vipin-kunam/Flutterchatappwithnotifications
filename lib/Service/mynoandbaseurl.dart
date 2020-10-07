var phoneno;
//var baseurl='http://192.168.0.250:3000/';
var baseurl='https://chat-backend96.herokuapp.com/';
var senderno;
var sendermessage;
var getcountofcontacts;
var myfcmtoken;
settoken(token){
  myfcmtoken =token;
}
gettoken(){
  return myfcmtoken;
}
setphoneno(no){
  phoneno=no;
}
getphoneno(){
  return phoneno;
}
getbaseurl(){
  return baseurl;
}
getsenderno(){
  return senderno;
}
setsenderno(message){
  senderno=message;
}
getsendermsg(){
  return sendermessage;
}
setsendermsg(msg){
  sendermessage=msg;
}