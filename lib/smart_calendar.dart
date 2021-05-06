import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:smart_calendar/controller/smart_calendar_controller.dart';

enum WeekDayType{short, medium, long}

enum CalendarType{civilCalendar, notCivilCalendar}

class SmartCalendar extends StatefulWidget {
  SmartCalendar({
    @required this.controller,
    @required this.initialDate,
    @required this.lastDate,
    @required this.locale,
    @required this.calendarType,
    @required this.weekdayType,
    this.onBackwardOrForward,
    this.onDayAddedOrRemoved,
  });

  final SmartCalendarController controller;
  final DateTime initialDate;
  final DateTime lastDate;
  final String locale;
  final CalendarType calendarType;
  final WeekDayType weekdayType;
  final Function(String month, int year) onBackwardOrForward;
  final Function(int day, int month, int year, List dates) onDayAddedOrRemoved;

  @override
  _SmartCalendarState createState() => _SmartCalendarState();
}

class _SmartCalendarState extends State<SmartCalendar> {
  @override
  void initState() {
    super.initState();
    setWeekDays();
  }

  setWeekDays() {
    switch (widget.calendarType) {
      case CalendarType.civilCalendar:
        initializeDateFormatting(widget.locale);
        for (int i = 1; i < getWeekDays().length; i++) {
          widget.controller.daysOfTheWeek.add(getWeekDays()[i]);
        }
        widget.controller.daysOfTheWeek.add(getWeekDays()[0]);
        widget.controller.months = getMonths();
        break;

      case CalendarType.notCivilCalendar:
        initializeDateFormatting(widget.locale);
        for (int i = 0; i < getWeekDays().length; i++) {
          widget.controller.daysOfTheWeek.add(getWeekDays()[i]);
        }
        widget.controller.months = getMonths();
        break;
    }
  }

  List getWeekDays(){
    return DateFormat('${widget.initialDate}', widget.locale).dateSymbols.WEEKDAYS;
  }

  List getMonths(){
    return DateFormat('${widget.initialDate}', widget.locale).dateSymbols.MONTHS;
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _initCalendar()
      ],
    );
  }

  _initCalendar() {
    widget.controller.calcNumberOfDays(
      calendarType: widget.calendarType,
      initialDate: widget.initialDate,
    );
    if (widget.controller.weekDay != 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: Get.width,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.controller.goBackWard(
                          calendarType: widget.calendarType,
                          initialDate: widget.initialDate,
                          function: widget.onBackwardOrForward
                        );
                      });
                    }),
                Obx(() => Text(
                    '${widget.controller.months[widget.controller.currentMonth - 1].toString().capitalizeFirst} - ${widget.controller.currentYear}')),
                IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.controller.goForWard(
                          calendarType: widget.calendarType,
                          lastDate: widget.lastDate,
                            function: widget.onBackwardOrForward
                        );
                      });
                    }),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                widget.controller.daysOfTheWeek.length,
                    (index) => Container(
                  width: 35,
                  height: 35,
                  child: Text(
                    _buildWeekDay(index),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _buildDayColor(index)),
                  ),
                )),
          ),
          _buildCalendar()
        ],
      );
    } else {
      return Container();
    }
  }

  _buildWeekDay(int index) {
    switch (widget.weekdayType) {
      case WeekDayType.short:
        return widget.controller.daysOfTheWeek[index]
            .toString()
            .substring(0, 1)
            .capitalize;
        break;
      case WeekDayType.medium:
        return widget.controller.daysOfTheWeek[index]
            .toString()
            .substring(0, 3)
            .capitalizeFirst;
        break;
      case WeekDayType.long:
        return widget.controller.daysOfTheWeek[index]
            .toString()
            .capitalizeFirst;
        break;
    }
  }

  _buildCalendar() {
    int numberOfWeeks =
    widget.controller.calcNumberOfWeeks(calendarType: widget.calendarType);
    switch (widget.calendarType) {
      case CalendarType.civilCalendar:
        return Column(
          children: List.generate(numberOfWeeks + 1, (index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildCalendarContent(index, numberOfWeeks),
                ),
              ),
            );
          }),
        );
        break;
      case CalendarType.notCivilCalendar:
        return Column(
          children: List.generate(numberOfWeeks, (index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildCalendarContent(index, numberOfWeeks),
                ),
              ),
            );
          }),
        );
        break;
    }
  }

  Widget _buildCalendarContent(int position, int numberOfWeeks) {
    if (position >= (numberOfWeeks - widget.controller.weekSize) + 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          return _showDay(index, position, numberOfWeeks);
        }),
      );
    } else {
      return Container();
    }
  }

  //This will check the day and set it to each position according with he day of week, depending on
  //the type of calendar that was selected by the user when his was calling the smartCalendar
  dynamic _showDay(int index, position, numberOfWeeks) {
    switch (widget.calendarType) {
      case CalendarType.civilCalendar:
        if (position == (numberOfWeeks - 5)) {
          if (index >= widget.controller.weekDay - 1) {
            int lastDay = 0;
            return _clickableText(
              position: position,
              index: index,
              day: widget.controller.numberOfDays[lastDay + index - widget.controller.weekDay + 2],
              child: Text(
                  '${widget.controller.numberOfDays[lastDay + index - widget.controller.weekDay + 2]}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _buildDayColor(index))),
            );
          } else {
            return Container(
              width: 35,
              height: 35,
            );
          }
        } else {
          int lastDay = 7;
          if (position == (numberOfWeeks - 5) + 1) {
            setState(() {
              lastDay = 7;
            });
          } else if (position == (numberOfWeeks - 5) + 2) {
            setState(() {
              lastDay = 14;
            });
          } else if (position == (numberOfWeeks - 5) + 3) {
            setState(() {
              lastDay = 21;
            });
          } else if (position == (numberOfWeeks - 5) + 4) {
            setState(() {
              lastDay = 28;
            });
          } else {
            setState(() {
              lastDay = 35;
            });
          }
          if (lastDay + index - widget.controller.weekDay + 2 >=
              widget.controller.numberOfDays.length) {
            return Container(
              width: 35,
              height: 35,
            );
          } else {
            return _clickableText(
              position: position,
              index: index,
              day: widget.controller.numberOfDays[lastDay + index - widget.controller.weekDay + 1] + 1,
              child: Text(
                  '${widget.controller.numberOfDays[lastDay + index - widget.controller.weekDay + 1] + 1}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _buildDayColor(index))),
            );
          }
        }
        break;

      case CalendarType.notCivilCalendar:
        if (position == (numberOfWeeks - 6)) {
          if (index >= widget.controller.weekDay - 1) {
            int lastDay = 0;
            return _clickableText(
              position: position,
              index: index,
              day: widget.controller.numberOfDays[lastDay + index - widget.controller.weekDay + 2],
              child: Text(
                  '${widget.controller.numberOfDays[lastDay + index - widget.controller.weekDay + 2]}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _buildDayColor(index))),
            );
          } else {
            return Container(
              width: 35,
              height: 35,
            );
          }
        } else {
          int lastDay = 7;
          if (position == (numberOfWeeks - 6) + 1) {
            setState(() {
              lastDay = 7;
            });
          } else if (position == (numberOfWeeks - 6) + 2) {
            setState(() {
              lastDay = 14;
            });
          } else if (position == (numberOfWeeks - 6) + 3) {
            setState(() {
              lastDay = 21;
            });
          } else if (position == (numberOfWeeks - 6) + 4) {
            setState(() {
              lastDay = 28;
            });
          } else {
            setState(() {
              lastDay = 35;
            });
          }
          if (lastDay + index - widget.controller.weekDay + 2 >=
              widget.controller.numberOfDays.length) {
            return Container(
              width: 35,
              height: 35,
            );
          } else {
            return _clickableText(
              position: position,
              index: index,
              day: widget.controller.numberOfDays[lastDay + index - widget.controller.weekDay + 1] + 1,
              child: Text(
                '${widget.controller.numberOfDays[lastDay + index - widget.controller.weekDay + 1] + 1}',
                textAlign: TextAlign.center,
                style: TextStyle(color: _buildDayColor(index)),
              ),
            );
          }
        }
        break;
    }
  }

  Widget _clickableText({
    @required int position,
    @required int index,
    @required int day,
    @required Widget child,
  }) {
    return Container(
        width: 35,
        height: 35,
        child: Obx(
              () => GestureDetector(
                onTap: () {
                  setState(() {
                    widget.controller.buildDayInset(position, index, day, widget.onDayAddedOrRemoved);
                  });
                  },
                child: Card(
                  elevation: 0,
                  color: widget.controller.buildCardColor(position, index, day),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  child: Center(
                    child: child,
                  ),
                ),
              ),
        ));
  }

  Color _buildDayColor(int index) {
    if (index >= 5) {
      return Colors.grey;
    } else {
      return Colors.black;
    }
  }
}
