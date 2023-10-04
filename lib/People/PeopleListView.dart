import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marryabook/Models/PersonModel.dart';
import 'package:marryabook/Firebase/FirebasePeopleController.dart';
import 'package:marryabook/People/CreatePersonView.dart';
import 'package:marryabook/People/PersonDetailView.dart';
import 'package:marryabook/People/PersonListTile.dart';
import 'package:marryabook/global.dart';

import '../Models/UserModel.dart';

class PeopleListView extends StatefulWidget {
  const PeopleListView({super.key, required this.user});
  final User user;

  @override
  State<PeopleListView> createState() => _PeopleListViewState();
}

class _PeopleListViewState extends State<PeopleListView> {

  final _usersStream = users.doc("CEjAxcZrJgY1K5wJaSqC").collection('people').snapshots();

  @override
  void initState() {
    // getUser("CEjAxcZrJgY1K5wJaSqC");
    print(widget.user);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        // future: ,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }


            // Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            // return Text("Name: ${data['name']} ${data['ap']}");
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> people = document.data()! as Map<String, dynamic>;
              Person personObj = Person.fromFirestore(people, document.reference.id);
              personList.add(personObj);
              return PersonListTile(person: personObj);
            }).toList(),
          );



        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePersonView()),
          );
        },
        tooltip: 'Create a Person',
        child: const Icon(Icons.add),
      ),
    );
  }
}
