import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MBCalendar extends StatefulWidget {
  const MBCalendar({super.key});

  @override
  State<MBCalendar> createState() => _MBCalendarState();
}

class _MBCalendarState extends State<MBCalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.week,
        dataSource: _getCalendarDataSource(),
        allowDragAndDrop: true
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
