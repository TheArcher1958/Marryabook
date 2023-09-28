// import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/PersonModel.dart';

class CreatePersonView extends StatefulWidget {
  const CreatePersonView({super.key});


  @override
  State<CreatePersonView> createState() => _CreatePersonViewState();
}

class _CreatePersonViewState extends State<CreatePersonView> {
  final nameController = TextEditingController();
  final notesController = TextEditingController();
  CollectionReference people = FirebaseFirestore.instance.collection('user').doc("CEjAxcZrJgY1K5wJaSqC").collection('people');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    notesController.dispose();
    super.dispose();
  }


  Future<void> addUser() {
    print(PersonStatus(Colors.yellow, Icons.circle).toJson());
    // Call the user's CollectionReference to add a new user
    return people
        .add({
      'name': nameController.text,
      'parentUser': "CEjAxcZrJgY1K5wJaSqC",
      'description': notesController.text,
      'status': PersonStatus(Colors.yellow, Icons.circle).toJson()
    })
        .then((value) => print("person Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            addUser();
            Navigator.pop(context);
          }, icon: const Icon(Icons.check))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Name',
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: notesController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Notes',
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          //   child: TextField(
          //     controller: myController,
          //     decoration: const InputDecoration(
          //       border: UnderlineInputBorder(),
          //       labelText: 'Enter your name',
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
