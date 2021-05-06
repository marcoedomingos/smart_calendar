import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_calendar/controller/smart_calendar_controller.dart';
import 'package:smart_calendar/smart_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final controller = SmartCalendarController();

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
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
                    locale: 'en_US',
                    calendarType: CalendarType.notCivilCalendar,
                    weekdayType: WeekDayType.medium,
                    onBackwardOrForward: (month, year){
                      print('This $month and this $year');
                    },
                    onDayAddedOrRemoved: (day, month, year, dates){
                      print('Selected date: $year-$month-$day \n $dates');
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
