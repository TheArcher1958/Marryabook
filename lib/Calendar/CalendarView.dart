import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:marryabook/Calendar/AppointmentEditor.dart';
import 'package:marryabook/Models/EventModel.dart';

class MBCalendar extends StatefulWidget {
  const MBCalendar({super.key});

  @override
  State<MBCalendar> createState() => _MBCalendarState();
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
  String _subject = '';
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
    _subject = '';
    _notes = '';


    if (calendarTapDetails.appointments != null &&
        calendarTapDetails.appointments?.length == 1) {
      final Event meetingDetails = calendarTapDetails.appointments![0];
      _startDate = meetingDetails.from;
      _endDate = meetingDetails.to;
      _isAllDay = meetingDetails.isAllDay;
      // _selectedColorIndex = _colorCollection.indexOf(meetingDetails.background);
      // _selectedTimeZoneIndex = meetingDetails.startTimeZone == ''
      //     ? 0
      //     : _timeZoneCollection.indexOf(meetingDetails.startTimeZone);
      _subject = meetingDetails.eventName == '(No title)'
          ? ''
          : meetingDetails.eventName;
      _notes = meetingDetails.description;
      // _selectedResourceIndex =
      //     _nameCollection.indexOf(calendarTapDetails.resource!.displayName);
      _selectedAppointment = meetingDetails;
    } else {
      final DateTime date = calendarTapDetails.date!;
      _startDate = date;
      _endDate = date.add(const Duration(hours: 1));
    }
    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    Navigator.push<Widget>(
      context,
      MaterialPageRoute(builder: (BuildContext context) => AppointmentEditor(startDate: _startDate)),
    );
  }





  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userEventsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

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

          )
        );
      }
    );
  }
}


_AppointmentDataSource _getCalendarDataSource(snapshot) {
  List<Event> events = <Event>[];
  print(snapshot.data);
  print(snapshot.data!.docs);
  snapshot.data!.docs.forEach((document) {
    Map<String, dynamic> fireEvent = document.data()! as Map<String, dynamic>;
    print(fireEvent);
    events.add(Event.fromFirestore(fireEvent, document.reference.id));
  });


  return _AppointmentDataSource(events);
}

class _AppointmentDataSource extends CalendarDataSource {
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

  @override
  String getStartTimeZone(int index) {
    return appointments![index].startTimeZone;
  }

  @override
  String getEndTimeZone(int index) {
    return appointments![index].endTimeZone;
  }

  @override
  Color getColor(int index) {
    return Color(appointments![index].color);
  }
}
