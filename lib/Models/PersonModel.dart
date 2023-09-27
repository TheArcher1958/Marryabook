import 'package:marryabook/Models/UserModel.dart';
import 'package:flutter/material.dart';

class Person {

  Person({required this.name, this.email = "", required this.id, this.phone = "", this.location = "", required this.parentUser, required this.status, this.description = ""});

  factory Person.fromFirestore(Map<dynamic, dynamic> json, id) {
    print(json.toString());
    return Person(
      id: id,
      name: json['name'],
      description: json['description'],
      parentUser: json['parentUser'],
      status: PersonStatus(Color(json['status']['color']), json['status']['shape'] == 57699 ? Icons.circle : Icons.star)
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "parentUser": parentUser,
  };
  final String name;
  final String email;
  final String id;
  final String phone;
  final String location;
  final String parentUser;
  final PersonStatus status;
  final String description;


}

class PersonStatus {

  PersonStatus(this.color, this.shape);
  Map<String, dynamic> toJson() => {
    "color": color.value,
    "shape": shape.codePoint,
  };
  final Color color;
  final IconData shape;
}
// enum Color { red, green, blue, yellow }

