import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../Service/mynoandbaseurl.dart';
IO.Socket socket;
createsocket(){
  if(socket==null){
  socket = IO.io(getbaseurl(),<String, dynamic>{
    'transports': ['websocket']});}
}

//socket.on('connect', (_) {
//socket.on('toclient', (data) => print(data));
//print('connect');
//socket.emit('fromclient', 'testing');
//});
//socket.on('connect_error', (err) {
//print('errorconecting');
//print(err);
//});
getsocket(){
  return socket;
}
getnewsocket(){
  IO.Socket socket1 = IO.io(getbaseurl(),<String, dynamic>{
    'transports': ['websocket']});
    return socket1;
}
