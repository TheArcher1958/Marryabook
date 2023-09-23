import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marryabook/Firebase/FirebasePeopleController.dart';

class PeopleListView extends StatefulWidget {
  const PeopleListView({super.key});

  @override
  State<PeopleListView> createState() => _PeopleListViewState();
}

class _PeopleListViewState extends State<PeopleListView> {

  @override
  void initState() {
    // getUser("CEjAxcZrJgY1K5wJaSqC");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: users.doc("CEjAxcZrJgY1K5wJaSqC").collection('people').get(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          // return Text("Name: ${data['name']} ${data['ap']}");
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> people = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(people['name']),
                subtitle: Text(people['description']),
              );
            }).toList(),
          );
        }

        return const Text("loading");
      }
    );
  }
}
