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
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
      return;
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
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
        dataSource: _getCalendarDataSource(),
        allowDragAndDrop: true,

      )
    );
  }
}


_AppointmentDataSource _getCalendarDataSource() {
  List<Appointment> appointments = <Appointment>[];
  appointments.add(Appointment(
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(minutes: 60)),
    subject: 'Travel',
    color: Colors.blue,
    startTimeZone: '',
    endTimeZone: '',
  ));

  appointments.add(Appointment(
    startTime: DateTime.now().subtract(const Duration(minutes: 60)),
    endTime: DateTime.now().add(const Duration(minutes: 30)),
    subject: 'Meeting',
    color: Colors.red,
    startTimeZone: '',
    endTimeZone: '',
  ));

  return _AppointmentDataSource(appointments);
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source){
    appointments = source;
  }
}
