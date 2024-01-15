import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:table_calendar/table_calendar.dart';
import '../schedule/schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work_Time App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<String, int> _monthlyClicks = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  List<DateTime> _selectedDays = [];

  @override
  void initState() {
    super.initState();
    _loadSelectedDays();
    _loadMonthlyClicks();
  }

  _loadSelectedDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedDates = prefs.getStringList('selectedDays') ?? [];
    setState(() {
      _selectedDays = savedDates.map((d) => DateTime.parse(d)).toList();
    });
  }

  _saveSelectedDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringDates = _selectedDays.map((d) => d.toIso8601String()).toList();
    await prefs.setStringList('selectedDays', stringDates);
  }

  _saveMonthlyClicks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('monthlyClicks', json.encode(_monthlyClicks));
  }
  _loadMonthlyClicks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? monthlyClicksString = prefs.getString('monthlyClicks');
    if (monthlyClicksString != null) {
      setState(() {
        _monthlyClicks = Map<String, int>.from(json.decode(monthlyClicksString));
      });
    }

  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      String monthKey = "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}";
      if (_selectedDays.any((day) => isSameDay(day, selectedDay))) {
        _selectedDays.removeWhere((day) => isSameDay(day, selectedDay));
        _monthlyClicks.update(monthKey, (value) => value - 1, ifAbsent: () => 0);
      } else {
        _selectedDays.add(selectedDay);
        _monthlyClicks.update(monthKey, (value) => value + 1, ifAbsent: () => 1);
      }
      _focusedDay = focusedDay;
      _saveSelectedDays();
      _saveMonthlyClicks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('排班表'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Schedule()));},
        ),

      ),
      body:  Column(
          children: <Widget>[
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              availableGestures: AvailableGestures.all,
              headerStyle: HeaderStyle(
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(25),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),

              ),
              calendarStyle: CalendarStyle(

                todayTextStyle:
                TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                todayDecoration:
                BoxDecoration(
                  color: Colors.lightBlueAccent,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle:
                TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                outsideDaysVisible: false,
              ),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              selectedDayPredicate: (day) {
                return _selectedDays.any((selectedDay) => isSameDay(selectedDay, day));
              },
              onDaySelected: _onDaySelected,
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, _) {
                  return  Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  );
                },

              ),

            ),
           Row(
             children: <Widget>[
               Container(
                 child: Row(
                     children: <Widget>[
                       Icon(Icons.work_history_outlined ,size: 50,),
                       Text(
                         ':${_monthlyClicks["${_focusedDay.year}-${_focusedDay.month.toString().padLeft(2, '0')}"] ?? 0}',
                         style: TextStyle(fontSize: 45.0),
                       ),

                     ]),

                 )
             ],
            ),
          ]
      )
    );

  }
}