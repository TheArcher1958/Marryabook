import 'package:flutter/material.dart';
import 'package:marryabook/Firebase/FirebaseDeleteDocument.dart';
import 'package:marryabook/Models/FirebaseResponseObject.dart';

import 'package:marryabook/Models/PersonModel.dart';
import 'package:marryabook/People/PersonDetailTimeline.dart';

class PersonDetailView extends StatefulWidget {
  const PersonDetailView({super.key, required this.person});

  final Person person;

  @override
  State<PersonDetailView> createState() => _PersonDetailViewState();
}

class _PersonDetailViewState extends State<PersonDetailView> {


  @override
  void initState() {
    // TODO: implement initState
    // print()
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.person.id);
    print(widget.person.name);
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
                itemBuilder: (context){
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("Delete ${widget.person.name}"),
                    ),

                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Settings"),
                    ),

                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text("Logout"),
                    ),
                  ];
                },
                onSelected:(value) async {
                  if(value == 0){
                    print("Deleting person");

                    FirebaseResponseObject? res = await deleteDocument(widget.person);
                    if (res?.res == 'Success') {
                      Navigator.pop(context);
                    } else {
                      print('Unable to delete document: ${res?.data}');
                    }
                  }else if(value == 1){
                    print("Settings menu is selected.");
                  }else if(value == 2){
                    print("Logout menu is selected.");
                  }
                }
            )
          ],
          backgroundColor: Colors.deepPurpleAccent,
          title: Text(widget.person.name),
            bottom: const TabBar(
              tabs: <Widget>[
              Tab(
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                icon: Icon(Icons.beach_access_sharp),
              ),
              Tab(
                icon: Icon(Icons.brightness_5_sharp),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            const Center(
              child: Text("It's cloudy here"),
            ),
            const Center(
              child: Text("It's rainy here"),
            ),
            Center(
              child: PersonDetailTimeline(person: widget.person),
            ),
          ],
        ),
      ),
    );
  }
}
