import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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


  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  //某月分天數數量
  Map<String, int> _monthlyClicks = {};
  //天數數量
  List<DateTime> _selectedDays = [];

  @override
  //重製
  void initState() {
    super.initState();
    _loadSelectedDays();
    _loadMonthlyClicks();
  }
  //天數載入
  _loadSelectedDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedDates = prefs.getStringList('selectedDays') ?? [];
    setState(() {
      _selectedDays = savedDates.map((d) => DateTime.parse(d)).toList();
    });
  }
  //天數儲存
  _saveSelectedDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringDates = _selectedDays.map((d) => d.toIso8601String()).toList();
    await prefs.setStringList('selectedDays', stringDates);
  }
  //月份天數儲存
  _saveMonthlyClicks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('monthlyClicks', json.encode(_monthlyClicks));
  }
  //月份天數載入
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
              locale: 'zh_CN',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              availableGestures: AvailableGestures.all,
              headerStyle: HeaderStyle(
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.purple, Colors.white70],
                  ),
                ),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
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

               Container(
                 child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: <Widget>[
                      Row(
                          children: <Widget>[
                            Icon(Icons.work_history_outlined ,size: 50,),
                            Text(
                              ':${_monthlyClicks["${_focusedDay.year}-${_focusedDay.month.toString().padLeft(2, '0')}"] ?? 0}',
                              style: TextStyle(fontSize: 45.0),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text(
                                '天/月',
                                style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,),
                              ),
                            )
                          ],
                      ),
                       Row(
                         children: [
                           Icon(Icons.work_history_outlined ,size: 50,),
                           Text(
                             ':'+_selectedDays.length.toString(),
                             style: TextStyle(fontSize: 45.0),
                           ),
                           Padding(
                             padding: EdgeInsets.only(top: 20.0),
                             child: Text(
                               '天/全',
                               style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,),
                             ),
                           )

                         ],
                       ),

                     ]),

                 )

          ]
      )
    );

  }
}