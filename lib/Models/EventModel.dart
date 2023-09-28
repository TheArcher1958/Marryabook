import 'package:flutter/material.dart';

class Event {
  Event(
      {required this.from,
        required this.to,
        this.color = 0x9c27b0,
        this.isAllDay = false,
        this.eventName = '',
        required this.parentUser,
        // this.startTimeZone = '',
        // this.endTimeZone = '',
        this.description = '',
        required this.ids});

  Map<String, dynamic> toJson() => {
    'startTime': from,
    'endTime': to,
    'color': color,
    'isAllDay': isAllDay,
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
  // final String startTimeZone;
  // final String endTimeZone;
  final String description;
  final List<String> ids;
}

enum EventType {
  contact, date, meal, studying, other
}