import 'dart:math';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:marryabook/Firebase/FirebaseEvents.dart';
import 'package:marryabook/Models/EventModel.dart';

import '../Models/PersonModel.dart';

class AppointmentEditor extends StatefulWidget {
  AppointmentEditor({super.key, required this.newEvent});
  Event newEvent;

  @override
  AppointmentEditorState createState() => AppointmentEditorState();
}

class AppointmentEditorState extends State<AppointmentEditor> {
  late String eventName = widget.newEvent.eventName;
  late Color eventColor = Color(widget.newEvent.color);
  late DateTime endDate = widget.newEvent.to;
  late DateTime startDate = widget.newEvent.from;
  late String eventDescription = widget.newEvent.description;
  late bool isAllDay = widget.newEvent.isAllDay;
  EventType eventType = EventType.other;
  List<Person> addedPeople = [];
  Event? _selectedAppointment;
  List<Event> events = [];

  // DateTime startDate = widget.newEvent.from;
  // DateTime endDate = startDate.add(const Duration(minutes: 60));
  late TimeOfDay endTime = TimeOfDay.fromDateTime(startDate.add(const Duration(minutes: 60)));
  late TimeOfDay startTime = TimeOfDay.fromDateTime(startDate);

  // TimeOfDay endTime = TimeOfDay.now();
  // TimeOfDay startTime = TimeOfDay.now();


  @override
  void initState() {
    // startDate = widget.newEvent.from;
    // endDate = widget.newEvent.from.add(const Duration(minutes: 60));
    // _addResourceDetails();
    // _employeeCollection = <CalendarResource>[];
    // _addResources();
    // _events = DataSource(getMeetingDetails(),_employeeCollection);
    _selectedAppointment = null;
    // _selectedColorIndex = 0;
    // _selectedTimeZoneIndex = 0;
    // _selectedResourceIndex = 0;
    // _subject = '';
    // _notes = '';
    super.initState();
  }
  // void _addResources() {
  //   Random random = Random();
  //   for (int i = 0; i < _nameCollection.length; i++) {
  //     _employeeCollection.add(CalendarResource(
  //       displayName: _nameCollection[i],
  //       id: '000' + i.toString(),
  //       color: Color.fromRGBO(
  //           random.nextInt(255), random.nextInt(255), random.nextInt(255), 1),
  //     ));
  //   }
  // }



  Widget _getAppointmentEditor(BuildContext context) {
    print(widget.newEvent.toJson());
    print(eventName);

    // DateTime endDate = startDate.add(const Duration(minutes: 60));
    return Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              leading: const Text(''),
              title: TextField(
                controller: TextEditingController(text: eventName),
                onChanged: (String value) {
                  eventName = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add title',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Icon(
                  Icons.access_time,
                  color: Colors.black54,
                ),
                title: Row(children: <Widget>[
                  const Expanded(
                    child: Text('All-day'),
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Switch(
                            value: isAllDay,
                            onChanged: (bool value) {
                              setState(() {
                                isAllDay = value;
                              });
                            },
                          ))),
                ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                                DateFormat('EEE, MMM dd yyyy')
                                    .format(startDate),
                                textAlign: TextAlign.left),
                            onTap: () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: startDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (date != null && date != startDate) {
                                setState(() {
                                  final Duration difference =
                                  endDate.difference(startDate);
                                  startDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      startDate.hour,
                                      startDate.minute,
                                      0);
                                  endDate = startDate.add(difference);
                                  endTime = TimeOfDay(
                                      hour: endDate.hour,
                                      minute: endDate.minute);
                                });
                              }
                            }),
                      ),
                      Expanded(
                          flex: 3,
                          child: isAllDay
                              ? const Text('')
                              : GestureDetector(
                              child: Text(
                                DateFormat('hh:mm a').format(startDate),
                                textAlign: TextAlign.right,
                              ),
                              onTap: () async {
                                final TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(startDate));

                                if (time != null && time != startDate) {
                                  setState(() {
                                    startTime = time;
                                    final Duration difference =
                                    endDate.difference(startDate);
                                    startDate = DateTime(
                                        startDate.year,
                                        startDate.month,
                                        startDate.day,
                                        startDate.hour,
                                        startDate.minute,
                                        0);
                                    endDate = startDate.add(difference);
                                    endTime = TimeOfDay(
                                        hour: endDate.hour,
                                        minute: endDate.minute);
                                  });
                                }
                              })),
                    ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                              DateFormat('EEE, MMM dd yyyy').format(endDate),
                              textAlign: TextAlign.left,
                            ),
                            onTap: () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: endDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (date != null && date != endDate) {
                                setState(() {
                                  final Duration difference =
                                  endDate.difference(startDate);
                                  endDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      endTime.hour,
                                      endDate.minute,
                                      0);
                                  if (endDate.isBefore(startDate)) {
                                    startDate = endDate.subtract(difference);
                                    startTime = TimeOfDay(
                                        hour: startDate.hour,
                                        minute: startDate.minute);
                                  }
                                });
                              }
                            }),
                      ),
                      Expanded(
                          flex: 3,
                          child: isAllDay
                              ? const Text('')
                              : GestureDetector(
                              child: Text(
                                DateFormat('hh:mm a').format(endDate),
                                textAlign: TextAlign.right,
                              ),
                              onTap: () async {
                                final TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: endTime);

                                if (time != null && time != endTime) {
                                  setState(() {
                                    endTime = time;
                                    final Duration difference =
                                    endDate.difference(startDate);
                                    endDate = DateTime(
                                        endDate.year,
                                        endDate.month,
                                        endDate.day,
                                        endTime.hour,
                                        endTime.minute,
                                        0);
                                    if (endDate.isBefore(startDate)) {
                                      startDate =
                                          endDate.subtract(difference);
                                      startTime= TimeOfDay(
                                          hour: startDate.hour,
                                          minute: startDate.minute);
                                    }
                                  });
                                }
                              })),
                    ])),
            // ListTile(
            //   contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            //   leading: const Icon(
            //     Icons.public,
            //     color: Colors.black87,
            //   ),
            //   title: Text(_timeZoneCollection[_selectedTimeZoneIndex]),
            //   onTap: () {
            //     showDialog<Widget>(
            //       context: context,
            //       barrierDismissible: true,
            //       builder: (BuildContext context) {
            //         return _TimeZonePicker();
            //       },
            //     ).then((dynamic value) => setState(() {}));
            //   },
            // ),
            // const Divider(
            //   height: 1.0,
            //   thickness: 1,
            // ),
            // ListTile(
            //   contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            //   leading: Icon(Icons.lens,
            //       color: _colorCollection[_selectedColorIndex]),
            //   title: Text(
            //     _colorNames[_selectedColorIndex],
            //   ),
            //   onTap: () {
            //     showDialog<Widget>(
            //       context: context,
            //       barrierDismissible: true,
            //       builder: (BuildContext context) {
            //         return _ColorPicker();
            //       },
            //     ).then((dynamic value) => setState(() {}));
            //   },
            // ),
            // const Divider(
            //   height: 1.0,
            //   thickness: 1,
            // ),




            // ListTile(
            //   contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            //   leading: const Icon(Icons.person_pin),
            //   title: Text(
            //     _nameCollection[_selectedResourceIndex],
            //   ),
            //   onTap: () {
            //     showDialog<Widget>(
            //       context: context,
            //       barrierDismissible: true,
            //       builder: (BuildContext context) {
            //         return _ResourcePicker();
            //       },
            //     ).then((dynamic value) => setState(() {}));
            //   },
            // ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.subject,
                color: Colors.black87,
              ),
              title: TextField(
                controller: TextEditingController(text: eventDescription),
                onChanged: (String value) {
                  eventDescription = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add description',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text(getTitle()),
              backgroundColor: Colors.blue,
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    icon: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      final List<Event> events = <Event>[];
                      if (_selectedAppointment != null) {
                        events.removeAt(
                            events.indexOf(_selectedAppointment!));
                        // events.notifyListeners(CalendarDataSourceAction.remove,
                        //     <Event>[]..add(_selectedAppointment!));
                      }

                      DateTime startDate = widget.newEvent.from;
                      DateTime endDate = startDate.add(const Duration(minutes: 60));

                      events.add(Event(
                          from: startDate,
                          to: endDate,
                          color: Colors.blue.value,
                          parentUser: 'tim',
                          // startTimeZone: _selectedTimeZoneIndex == 0
                          //     ? ''
                          //     : _timeZoneCollection[_selectedTimeZoneIndex],
                          // endTimeZone: _selectedTimeZoneIndex == 0
                          //     ? ''
                          //     : _timeZoneCollection[_selectedTimeZoneIndex],
                          description: eventDescription,
                          isAllDay: isAllDay,
                          eventName: eventName == '' ? '(No title)' : eventName,
                          ids: <String>[]
                      ));

                      // events.add(events[0]);
                      addEvent(events[0]);

                      // events.notifyListeners(
                      //     CalendarDataSourceAction.add, meetings);
                      _selectedAppointment = null;

                      Navigator.pop(context);
                    })
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Stack(
                children: <Widget>[_getAppointmentEditor(context)],
              ),
            ),
            floatingActionButton: _selectedAppointment == null
                ? const Text('')
                : FloatingActionButton(
              onPressed: () {
                if (_selectedAppointment != null) {
                  events.removeAt(
                      events.indexOf(_selectedAppointment!));
                  // events.notifyListeners(CalendarDataSourceAction.remove,
                  //     <Event>[]..add(_selectedAppointment!));
                  _selectedAppointment = null;
                  Navigator.pop(context);
                }
              },
              backgroundColor: Colors.red,
              child:
              const Icon(Icons.delete_outline, color: Colors.white),
            )));
  }

  String getTitle() {
    return eventName.isEmpty ? 'New event' : 'Event details';
  }
}