import 'package:marryabook/Models/EventModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference events = FirebaseFirestore.instance.collection('user').doc("CEjAxcZrJgY1K5wJaSqC").collection('events');

Future<void> addEvent(Event event) {
  print(event.color);
  print(event.toJson());
  // Call the event's CollectionReference to add a new event
  return events
      .add({
    'name': event.eventName,
    'startTime': event.from,
    'endTime': event.to,
    'color': event.color,
    'isAllDay': event.isAllDay,
    'addedPeople': event.ids,
    'parentUser': "CEjAxcZrJgY1K5wJaSqC",
    'description': event.description,
  })
      .then((value) => print("event Added"))
      .catchError((error) => print("Failed to add event: $error"));
}