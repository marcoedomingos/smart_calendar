import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_calendar/controller/smart_calendar_controller.dart';
import 'package:smart_calendar/smart_calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = SmartCalendarController(
    initialDate: DateTime.now(),
    lastDate: DateTime.utc(2053, 04, 31),
    eventDates: [
      {
        "date": "2021-05-01",
        "description": "This a holiday because of the Worker day",
        "title": "Worker Day"
      },
      {
        "date": "2021-06-01",
        "description": "This a holiday because of the Kids day",
        "title": "Kids Day"
      },
      {
        "date": "2021-09-17",
        "description": "This a holiday because of the hero day",
        "title": "Hero day"
      }
    ],
    annualEvents: false,
    locale: 'en_US',
    calendarType: CalendarType.civilCalendar,
    weekdayType: WeekDayType.medium,
  );
  var month = 'Mês';
  var year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
            child: Container(
          width: Get.width / 1,
          child: Column(
            children: [
              SmartCalendar(
                controller: controller,
                onBackwardOrForward: (month, year) {
                  setState(() {
                    this.month = month;
                    this.year = year;
                  });
                  print('This $month and this $year');
                },
                onDayAddedOrRemoved: (day, month, monthName, year, dates) {
                  print('Selected date: $year-$monthName-$day \n $dates');
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
