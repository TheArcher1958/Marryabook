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
        this.ids,


        // this.exceptionDates,
        // this.recurrenceRule,
        // this.recurrenceId,
        // this.background,
        this.eventId = '',
      });

  factory Event.fromFirestore(Map<dynamic, dynamic> json, id) {
    return Event(
        from: DateTime.parse(json['startTime'].toDate().toString()),
        to: DateTime.parse(json['endTime'].toDate().toString()),
        isAllDay: json['isAllDay'] ?? false,
        eventName: json['name'],
        eventId: id,
        description: json['description'] ?? '',
        parentUser: json['parentUser'] ?? '',
        ids: json['ids'],
        color: json['color'],
    );
  }

  Map<String, dynamic> toJson() => {
    'startTime': from,
    'endTime': to,
    'color': color,
    'ids': ids,
    'isAllDay': isAllDay,
    'startTimeZone': 'Central America Standard Time',
    'endTimeZone': 'Central America Standard Time',
    'description': description,
    "name": eventName,
    "parentUser": parentUser,
  };


  String eventName;
  final DateTime from;
  final DateTime to;
  final String parentUser;
  int color;
  bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;
  String description;
  List<dynamic>? ids;

  // Color? background;
  // Object? recurrenceId;
  // String? fromZone;
  // String? toZone;
  // String? recurrenceRule;
  // List<DateTime>? exceptionDates;
  String eventId;
}

enum EventType {
  contact, date, meal, studying, other
}