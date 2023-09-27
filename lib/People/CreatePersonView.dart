import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/PersonModel.dart';

class CreatePersonView extends StatefulWidget {
  const CreatePersonView({super.key});


  @override
  State<CreatePersonView> createState() => _CreatePersonViewState();
}

class _CreatePersonViewState extends State<CreatePersonView> {
  final myController = TextEditingController();
  CollectionReference people = FirebaseFirestore.instance.collection('user').doc("CEjAxcZrJgY1K5wJaSqC").collection('people');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Future<void> addUser() {
    print(PersonStatus(Colors.yellow, Icons.circle).toJson());
    // Call the user's CollectionReference to add a new user
    return people
        .add({
      'name': myController.text,
      'parentUser': "CEjAxcZrJgY1K5wJaSqC",
      'description': 'The weird kid from high school',
      'status': PersonStatus(Colors.yellow, Icons.circle).toJson()
    })
        .then((value) => print("person Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: myController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your name',
              ),
            ),
          ),

          FloatingActionButton(
            // When the user presses the button, show an alert dialog containing
            // the text that the user has entered into the text field.
            onPressed: () {

              addUser();
              Navigator.pop(context);
            },
            tooltip: 'Show me the value!',
            child: const Icon(Icons.text_fields),
          ),
        ],
      ),
    );
  }
}
