import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marryabook/Firebase/FirebasePeopleController.dart';
import 'package:marryabook/People/CreatePersonView.dart';

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
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
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
                  subtitle: Text(people?['description']),
                );
              }).toList(),
            );
          }

          return const Text("loading");
        }
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePersonView()),
          );
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}
