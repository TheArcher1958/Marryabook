import 'package:marryabook/Models/UserModel.dart';

class Person {

  Person({required this.name, this.email = "", required this.id, this.phone = "", this.location = "", required this.parentUser});

  factory Person.fromFirestore(Map<dynamic, dynamic> json) {
    return Person(
      id: json['uid'],
      name: json['name'],
      parentUser: User("name","email","id"),
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
  final User parentUser;


}

