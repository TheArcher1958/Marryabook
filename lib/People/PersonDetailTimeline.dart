import 'package:flutter/material.dart';
import 'package:marryabook/global.dart';
import '../Models/PersonModel.dart';
import 'package:marryabook/Models/EventModel.dart';


class PersonDetailTimeline extends StatefulWidget {
  const PersonDetailTimeline({super.key, required this.person});

  final Person person;

  @override
  State<PersonDetailTimeline> createState() => _PersonDetailTimelineState();
}

class _PersonDetailTimelineState extends State<PersonDetailTimeline> {
  List<Event> timelineEvents = [];

  @override
  void initState() {
    for (Event i in eventList) {

      print(i.ids == null);
      if (i.ids == null) return;

      if (i.ids!.contains(widget.person.id)) {
        print(i.ids.toString());
        timelineEvents.add(i);
        print(i.eventName);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return ListView(
      children: const <Widget>[
        ListTile(
          leading: Icon(Icons.map),
          title: Text('Map'),
        ),
        ListTile(
          leading: Icon(Icons.photo_album),
          title: Text('Album'),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('Phone'),
        ),
      ],
    );
  }
}
