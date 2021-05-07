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
  final controller = SmartCalendarController();
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
                    initialDate: DateTime.now(),
                    lastDate: DateTime.utc(2022, 12, 31),
                    locale: 'pt_BR',
                    calendarType: CalendarType.civilCalendar,
                    weekdayType: WeekDayType.medium,
                    customTitleWidget: Container(
                      width: Get.width / 1.02,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Calendário'),
                          Text('$month-$year')
                        ],
                      ),
                    ),
                    onBackwardOrForward: (month, year){
                      setState(() {
                        this.month = month;
                        this.year = year;
                      });
                      print('This $month and this $year');
                    },
                    onDayAddedOrRemoved: (day, month, monthName, year, dates){
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
