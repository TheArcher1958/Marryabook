import 'package:flutter/material.dart';
import 'package:marryabook/Models/PersonModel.dart';

import 'package:marryabook/global.dart';

class PersonPicker extends StatefulWidget {
  const PersonPicker({super.key});

  @override
  State<StatefulWidget> createState() {
    return PersonPickerState();
  }
}

class PersonPickerState extends State<PersonPicker> {
  late Person selectedPerson;

  @override
  Widget build(BuildContext context) {
    print(personList.length);
    return AlertDialog(
      content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: personList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Text(personList[index].name),
                onTap: () {
                  setState(() {
                    selectedPerson = personList[index];
                  });

                  // ignore: always_specify_types
                  Future.delayed(const Duration(milliseconds: 200), () {
                    // When task is over, close the dialog
                    Navigator.pop(context, selectedPerson);
                  });
                },
              );
            },
          )),
    );
  }
}