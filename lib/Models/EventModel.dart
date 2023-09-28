import 'package:flutter/material.dart';

class Event {
  Event({
        required this.from,
        required this.to,
        this.color = 0x9c27b0,
        this.isAllDay = false,
        this.eventName = '',
        required this.parentUser,
        this.startTimeZone = '',
        this.endTimeZone = '',
        this.description = '',
        required this.ids
      });

  factory Event.fromFirestore(Map<dynamic, dynamic> json, id) {
    print(json.toString());
    return Event(
        from: DateTime.parse(json['startTime'].toDate().toString()),
        to: DateTime.parse(json['endTime'].toDate().toString()),
        isAllDay: json['isAllDay'] ?? false,
        eventName: json['name'],
        description: json['description'] ?? '',
        parentUser: json['parentUser'] ?? '',
        ids: json['addedPeople'] ?? [],
        color: json['color'],
    );
  }

  Map<String, dynamic> toJson() => {
    'startTime': from,
    'endTime': to,
    'color': color,
    'isAllDay': isAllDay,
    'startTimeZone': 'Central America Standard Time',
    'endTimeZone': 'Central America Standard Time',
    'description': description,
    "name": eventName,
    "parentUser": parentUser,
  };

  final String eventName;
  final DateTime from;
  final DateTime to;
  final String parentUser;
  final int color;
  final bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;

  final String description;
  final List<dynamic> ids;
}

enum EventType {
  contact, date, meal, studying, other
}