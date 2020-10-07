import 'dart:convert';

Recipiant RecipiantFromJson(String str) {
  final jsonData = json.decode(str);
  return Recipiant.fromMap(jsonData);
}

String RecipiantToJson(Recipiant data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Recipiant {
  int id;
  String firstName;
  String lastName;
  bool blocked;
  String phoneno;

  Recipiant({
    this.id,
    this.firstName,
    this.lastName,
    this.blocked,
    this.phoneno,
  });

  factory Recipiant.fromMap(Map<String, dynamic> json) => new Recipiant(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    blocked: json["blocked"] == 1,
    phoneno: json["phoneno"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "blocked": blocked,
    "phoneno":phoneno,
  };
}