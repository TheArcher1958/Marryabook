import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marryabook/Firebase/FirebaseEvents.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:marryabook/Calendar/AppointmentEditor.dart';
import 'package:marryabook/Models/EventModel.dart';

class MBCalendar extends StatefulWidget {
  const MBCalendar({super.key});

  @override
  State<MBCalendar> createState() => _MBCalendarState();
}





class Meeting {
  Meeting(
      {required this.from,
        required this.to,
        this.id,
        this.recurrenceId,
        this.eventName = '',
        this.isAllDay = false,
        this.background,
        this.exceptionDates,
        this.recurrenceRule});

  DateTime from;
  DateTime to;
  Object? id;
  Object? recurrenceId;
  String eventName;
  bool isAllDay;
  Color? background;
  String? fromZone;
  String? toZone;
  String? recurrenceRule;
  List<DateTime>? exceptionDates;
}





class _MBCalendarState extends State<MBCalendar> {
  final Stream<QuerySnapshot> _userEventsStream = FirebaseFirestore.instance.collection('user').doc("CEjAxcZrJgY1K5wJaSqC").collection('events').snapshots();
  // late List<Color> _colorCollection;
  // late List<String> _colorNames;
  // int _selectedColorIndex = 0;
  // int _selectedTimeZoneIndex = 0;
  // int _selectedResourceIndex = 0;
  // late List<String> _timeZoneCollection;
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  late bool _isAllDay;
  late Color _color;
  String _eventName = '';
  late String _description;
  late List<dynamic>? _eventIds;
  String _notes = '';
  // late List<CalendarResource> _employeeCollection;
  // late List<String> _nameCollection;
  Event? _selectedAppointment;

  final CalendarController _controller = CalendarController();




  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    print('\n\n\n\n');
    print(calendarTapDetails.targetElement);
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
      return;
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
      return;
    } else if (calendarTapDetails.targetElement == CalendarElement.header) {
      print('tapped header');
      return;
    }


    _selectedAppointment = null;
    _isAllDay = false;
    _eventName = '';
    _notes = '';


    Event newEvent;
    if (calendarTapDetails.appointments != null &&
        calendarTapDetails.appointments?.length == 1) {
      final Event meetingDetails = calendarTapDetails.appointments![0];
      print('event tapped!');
      print(meetingDetails.toJson());
      _startDate = meetingDetails.from;
      _endDate = meetingDetails.to;
      _isAllDay = meetingDetails.isAllDay;
      _color = Color(meetingDetails.color);
      _description = meetingDetails.description;
      _eventIds = meetingDetails.ids;
      print(meetingDetails.ids);
      // _selectedColorIndex = _colorCollection.indexOf(meetingDetails.background);
      // _selectedTimeZoneIndex = meetingDetails.startTimeZone == ''
      //     ? 0
      //     : _timeZoneCollection.indexOf(meetingDetails.startTimeZone);
      _eventName = meetingDetails.eventName == '(No title)'
          ? ''
          : meetingDetails.eventName;
      // _selectedResourceIndex =
      //     _nameCollection.indexOf(calendarTapDetails.resource!.displayName);
      _selectedAppointment = meetingDetails;
      newEvent = Event(eventName: _eventName, from: _startDate, to: _endDate, isAllDay: _isAllDay, color: Colors.red.value, parentUser: meetingDetails.parentUser, ids: _eventIds, description: _description);
    } else {
      final DateTime date = calendarTapDetails.date!;
      _startDate = date;
      _endDate = date.add(const Duration(hours: 1));
      _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
      _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
      // _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day, _startDate.hour, _startDate.minute);
      newEvent = Event(from: _startDate, to: _endDate, color: Colors.red.value, parentUser: "Fred", ids: [], description: '');
    }

    Navigator.push<Widget>(
      context,
      MaterialPageRoute(builder: (BuildContext context) => AppointmentEditor(newEvent: newEvent)),
    );
  }





  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userEventsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // for (var value in snapshot.data!.docs) {
        //   print(value.data());
        // }


        return Scaffold(
          body: SfCalendar(
            showDatePickerButton: true,
            showTodayButton: true,
            view: CalendarView.day,
            allowedViews: const [
              CalendarView.day,
              CalendarView.week,
              CalendarView.month,
            ],
            controller: _controller,
            onTap: calendarTapped,
            dataSource: _getCalendarDataSource(snapshot),
            allowDragAndDrop: true,
            onDragStart: dragStart,
            onDragEnd: dragEnd,
            onDragUpdate: dragUpdate,

          )
        );
      }
    );
  }

}


_AppointmentDataSource _getCalendarDataSource(snapshot) {
  List<Event> events = <Event>[];
  if (snapshot.data != null) {
    snapshot.data!.docs.forEach((document) {
      Map<String, dynamic> fireEvent = document.data()! as Map<String, dynamic>;
      // print(fireEvent);
      events.add(Event.fromFirestore(fireEvent, document.reference.id));
      print(events.length);
    });
  }

  return _AppointmentDataSource(events);


}


void dragStart(AppointmentDragStartDetails appointmentDragStartDetails) {

}

void dragEnd(AppointmentDragEndDetails appointmentDragEndDetails) {

  updateEvent(appointmentDragEndDetails.appointment);
}


void dragUpdate(AppointmentDragUpdateDetails appointmentDragUpdateDetails) {

}

class _AppointmentDataSource extends CalendarDataSource<Event> {
  _AppointmentDataSource(List<Event> source){
    appointments = source;
  }
  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  // @override
  // String getStartTimeZone(int index) {
  //   return appointments![index].startTimeZone;
  // }
  //
  // @override
  // String getEndTimeZone(int index) {
  //   return appointments![index].endTimeZone;
  // }

  @override
  Color getColor(int index) {
    return Color(appointments![index].color);
  }

  // @override
  // List<DateTime>? getRecurrenceExceptionDates(int index) {
  //   return appointments![index].exceptionDates as List<DateTime>?;
  // }

  // @override
  // String? getRecurrenceRule(int index) {
  //   return appointments![index].recurrenceRule;
  // }

  // @override
  // Object? getRecurrenceId(int index) {
  //   return appointments![index].recurrenceId as Object?;
  // }

  // @override
  // Object? getId(int index) {
  //   return appointments![index].id;
  // }





  // @override
  // Meeting convertAppointmentToObject(
  //     Meeting customData, Appointment appointment) {
  //   return Meeting(
  //       from: appointment.startTime,
  //       to: appointment.endTime,
  //       content: appointment.subject,
  //       background: appointment.color,
  //       isAllDay: appointment.isAllDay);
  // }


  @override
  Event convertAppointmentToObject(
      Event customData, Appointment appointment) {
    // TODO: implement convertAppointmentToObject

    return Event(
        from: appointment.startTime,
        to: appointment.endTime,
        eventName: appointment.subject,
        color: appointment.color.value,
        isAllDay: appointment.isAllDay,
        ids: customData.ids,
        description: customData.description,
        // id: appointments.id,
        eventId: customData.eventId,
        parentUser: 'Test User',
        // recurrenceRule: appointment.recurrenceRule,
        // recurrenceId: appointment.recurrenceId,
        // exceptionDates: appointment.recurrenceExceptionDates,


      );
  }
}
