import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testing_app/Models/Contacts.dart';
import '../Models/Contacts.dart';
import 'package:sqflite/sqflite.dart';
import './mynoandbaseurl.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Chat.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE if not exists  Recipiant ("
              "id INTEGER PRIMARY KEY,"
              "first_name TEXT,"
              "last_name TEXT,"
              "blocked BIT,"
              "phoneno TEXT"
              ")");
          await db.execute("CREATE TABLE if not exists Login ("
              "id INTEGER PRIMARY KEY,"
              "phoneno TEXT"
              ")");
          await db.execute("CREATE TABLE if not exists  Messages ("
              "id INTEGER PRIMARY KEY,"
              "message TEXT,"
              "sender TEXT,"
              "receiver TEXT,"
              "selected BIT,"
              "date TEXT"
              ")");
        });
  }

  newRecipiant(Recipiant newRecipiant) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Recipiant");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Recipiant (id,first_name,last_name,blocked,phoneno)"
            " VALUES (?,?,?,?,?)",
        [id, newRecipiant.firstName, newRecipiant.lastName, newRecipiant.blocked,newRecipiant.phoneno]);
    return raw;
  }
  insertuser(phoneno) async{
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Login");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into Login (id,phoneno)"
            " VALUES (?,?)",
        [id, phoneno]);
    return raw;

  }
  getuser() async{
    final db = await database;
    var res = await db.query("Login");
    return res.isNotEmpty ? res.first : null;
  }

  blockOrUnblock(Recipiant recipiant) async {
    final db = await database;
    Recipiant blocked =  Recipiant(
        id: recipiant.id,
        firstName: recipiant.firstName,
        lastName: recipiant.lastName,
        blocked: !recipiant.blocked,
        phoneno:recipiant.phoneno);
    var res = await db.update("Recipiant", blocked.toMap(),
        where: "id = ?", whereArgs: [recipiant.id]);
    return res;
  }

  updateRecipiant(Recipiant newRecipiant) async {
    final db = await database;
    var res = await db.update("Recipiant", newRecipiant.toMap(),
        where: "id = ?", whereArgs: [newRecipiant.id]);
    return res;
  }

  getRecipiant(int id) async {
    final db = await database;
    var res = await db.query("Recipiant", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Recipiant.fromMap(res.first) : null;
  }
  getRecipiantbyno(int no) async {
    final db = await database;
    var res = await db.query("Recipiant", where: "phoneno = ?", whereArgs: [no]);
    return res.isNotEmpty ? res : null;
  }

  Future<List<Recipiant>> getBlockedRecipiants() async {
    final db = await database;

    print("works");
    // var res = await db.rawQuery("SELECT * FROM Recipiant WHERE blocked=1");
    var res = await db.query("Recipiant", where: "blocked = ? ", whereArgs: [1]);

    List<Recipiant> list =
    res.isNotEmpty ? res.map((c) => Recipiant.fromMap(c)).toList() : [];
    return [...list];
  }

  Future<List<Recipiant>> getAllRecipiants() async {
    final db = await database;
    var res = await db.query("Recipiant");
    List<Recipiant> list =
    res.isNotEmpty ? res.map((c) => Recipiant.fromMap(c)).toList() : [];
    return list;
  }

  deleteRecipiant(int id) async {
    final db = await database;
    return db.delete("Recipiant", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    return db.rawDelete("Delete from Recipiant");
  }
  Future<List<dynamic>> getAllMessages(sender,receiver) async {
    final db = await database;
//    var res= await db.rawQuery("SELECT * FROM Messages where sender = ? AND receiver = ? OR sender = ? AND receiver = ? ORDER BY date(date) DESC"
//    ,[sender,receiver,receiver,sender]);
    var res = await db.query("Messages",where: "sender = ? AND receiver = ? OR sender = ? AND receiver = ? ", whereArgs: [sender,receiver,receiver,sender]);

    return [...res];
  }
  getmessagebyid(id) async{
    final db = await database;
    var res = await db.query("Messages",where: "id = ? ", whereArgs: [id]);

    return [...res];
  }
  insertmessage(msg,from,to) async{
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Messages");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into Messages (id,message,sender,receiver,date,selected)"
            " VALUES (?,?,?,?,datetime(),0)",
        [id, msg,from,to]);
    return raw;
  }
  deletemessagebyid(id) async{
    final db = await database;
    return db.delete("Messages", where: "id = ?", whereArgs: [id]);
  }
}

//"id INTEGER PRIMARY KEY,"
//"message TEXT,"
//"sender TEXT,"
//"receiver TEXT,"
//"date TEXT"