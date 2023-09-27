import 'package:flutter/material.dart';

import '../Models/PersonModel.dart';
import 'PersonDetailView.dart';

class PersonListTile extends StatelessWidget {
  const PersonListTile({super.key, required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(person.status.shape, color: person.status.color,),
      title: Text(person.name),
      subtitle: Text(person.description),
      onTap: () {
        // print(people.toString());
        // print(document.reference.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PersonDetailView(
            person: Person(name: person.name,id: person.id, parentUser: person.parentUser, status: person.status)
          ))
        );
      },
    );
  }
}
