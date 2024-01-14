import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../schedule/schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  List<DateTime> _selectedDays = [];

  @override
  void initState() {
    super.initState();
    _loadSelectedDays();
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedDays.any((day) => isSameDay(day, selectedDay))) {
        _selectedDays.removeWhere((day) => isSameDay(day, selectedDay));
      } else {
        _selectedDays.add(selectedDay);
      }
      _focusedDay = focusedDay;
      _saveSelectedDays();
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
      body: TableCalendar(
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2050, 12, 31),
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
        selectedDayPredicate: (day) {
          return _selectedDays.any((selectedDay) => isSameDay(selectedDay, day));
        },
        onDaySelected: _onDaySelected,
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, _) {
            return Container(
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
    );
  }
}