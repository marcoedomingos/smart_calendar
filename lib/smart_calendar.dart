import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:smart_calendar/controller/smart_calendar_controller.dart';

class SmartCalendar extends StatefulWidget {
  SmartCalendar({
    @required this.controller,
    this.customTitleWidget,
    this.onBackwardOrForward,
    this.onDayAddedOrRemoved,
  });

  final SmartCalendarController controller;
  final Widget customTitleWidget;
  final Function(String month, int year) onBackwardOrForward;
  final Function(int day, int month, String monthName, int year, List dates)
      onDayAddedOrRemoved;

  @override
  _SmartCalendarState createState() => _SmartCalendarState();
}

class _SmartCalendarState extends State<SmartCalendar> {
  @override
  void initState() {
    super.initState();
    setWeekDaysAndMonths();
  }

  //This method will set the weekdays on the language that was inserted on the locale
  //and will order according to the type of the calendar inserted this method
  //is the first to run on the initialization of this class
  setWeekDaysAndMonths() {
    switch (widget.controller.calendarType) {
      case CalendarType.civilCalendar:
        initializeDateFormatting(widget.controller.locale);
        for (int i = 1; i < getWeekDays().length; i++) {
          widget.controller.daysOfTheWeek.add(getWeekDays()[i]);
        }
        widget.controller.daysOfTheWeek.add(getWeekDays()[0]);
        widget.controller.months = getMonths();
        break;

      case CalendarType.notCivilCalendar:
        initializeDateFormatting(widget.controller.locale);
        for (int i = 0; i < getWeekDays().length; i++) {
          widget.controller.daysOfTheWeek.add(getWeekDays()[i]);
        }
        widget.controller.months = getMonths();
        break;
    }
  }

  //This method get the weekdays according to the locale inserted
  //and is called on the setWeekDaysAndMonths() method
  List getWeekDays() {
    return DateFormat(
            '${widget.controller.initialDate}', widget.controller.locale)
        .dateSymbols
        .WEEKDAYS;
  }

  //This method get the months according to the locale inserted
  //and is called on the setWeekDaysAndMonths() method
  List getMonths() {
    return DateFormat(
            '${widget.controller.initialDate}', widget.controller.locale)
        .dateSymbols
        .MONTHS;
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
      children: [_initCalendar()],
    );
  }

  //This method initialize the full calendar widget, set the default dates
  //and return the Calendar already build
  _initCalendar() {
    widget.controller.calcNumberOfDays();
    if (widget.controller.lastDate.year >= widget.controller.initialDate.year) {
      if (widget.controller.lastDate.year >
          widget.controller.initialDate.year) {
        if (widget.controller.weekDay != 0) {
          return _showCalendar();
        } else {
          return Container();
        }
      } else {
        if (widget.controller.lastDate.month >=
            widget.controller.initialDate.month) {
          if (widget.controller.weekDay != 0) {
            return _showCalendar();
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      }
    } else {
      if (widget.controller.initialDate.month >=
          widget.controller.lastDate.month) {
        if (widget.controller.weekDay != 0) {
          return _showCalendar();
        } else {
          return Container();
        }
      } else {
        return Container();
      }
    }
  }

  //This method show the full calendar widget
  _showCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _buildMonthCalendar(context);
          },
          child: _buildCustomTitleWidget(),
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
                      style: TextStyle(
                          color: widget.controller.buildWeekendColor(index)),
                    ),
                  )),
        ),
        GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity > 0) {
              setState(() {
                widget.controller
                    .goBackWard(function: widget.onBackwardOrForward);
              });
            } else if (details.primaryVelocity < 0) {
              setState(() {
                widget.controller
                    .goForWard(function: widget.onBackwardOrForward);
              });
            }
          },
          child: _buildCalendar(),
        )
      ],
    );
  }

  //This method build the month calendar on a snackBar
  //in case the user click on the title widget
  _buildMonthCalendar(BuildContext context) {
    var snackBar = SnackBar(
        duration: Duration(days: 1),
        content: Column(
          mainAxisSize: MainAxisSize.min,
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
                          widget.controller.goBackWardInYear(
                              function: widget.onBackwardOrForward);
                        });
                      }),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      _buildYearCalendar(context);
                    },
                    child: Obx(() => Text('${widget.controller.currentYear}')),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.controller.goForWardInYear(
                              function: widget.onBackwardOrForward);
                        });
                      }),
                ],
              ),
            ),
            Container(
              width: Get.width,
              height: 200,
              child: GridView.builder(
                padding:
                    EdgeInsets.only(left: 5.0, right: 5.0, top: 10, bottom: 10),
                itemCount: widget.controller.months.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 2.2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      setState(() {
                        widget.controller.currentMonth = index + 1;
                        widget.controller.calcNumberOfDays(
                            function: widget.onBackwardOrForward);
                      });
                    },
                    child: Card(
                      color: _buildMonthCardColor(index),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80)),
                      child: Container(
                        width: 25,
                        height: 25,
                        child: Center(
                            child: Obx(() => Text(
                                  widget.controller.months[index]
                                      .toString()
                                      .capitalizeFirst,
                                  style: TextStyle(color: Colors.white),
                                ))),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //This method build the year calendar on a snackBar
  //in case the user click on the title widget
  _buildYearCalendar(BuildContext context) {
    var snackBar = SnackBar(
        duration: Duration(days: 1),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Get.width,
              height: 50,
              child: Center(
                child: Text(
                  'Calendário',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              width: Get.width,
              height: 200,
              child: GridView.builder(
                padding:
                    EdgeInsets.only(left: 5.0, right: 5.0, top: 10, bottom: 10),
                itemCount: widget.controller.getDifferenceBetweenYears(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 2.2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      setState(() {
                        widget.controller.currentYear =
                            widget.controller.initialDate.year + index;
                        widget.controller.calcNumberOfDays(
                            function: widget.onBackwardOrForward);
                        _buildMonthCalendar(context);
                      });
                    },
                    child: Card(
                      color: _buildYearCardColor(index),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80)),
                      child: Container(
                        width: 25,
                        height: 25,
                        child: Center(
                            child: Text(
                          '${widget.controller.initialDate.year + index}',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //This method return the the color of the card depending
  //if the month is the current month or not
  _buildMonthCardColor(int index) {
    if ((widget.controller.currentMonth - 1) == index) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  //This method return the the color of the card depending
  //if the year is the current year or not
  _buildYearCardColor(int index) {
    if (widget.controller.currentYear ==
        widget.controller.initialDate.year + index) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  //This method build the title widget depending if there is
  //a custom one or will use the default title widget
  _buildCustomTitleWidget() {
    if (widget.customTitleWidget != null) {
      return widget.customTitleWidget;
    } else {
      return Container(
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
                    widget.controller
                        .goBackWard(function: widget.onBackwardOrForward);
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
                    widget.controller
                        .goForWard(function: widget.onBackwardOrForward);
                  });
                }),
          ],
        ),
      );
    }
  }

  //This method return the names of the each weekday, but first he check
  //the type of weekday he will return, short, medium or long
  _buildWeekDay(int index) {
    switch (widget.controller.weekdayType) {
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

  //This method build the calendar widget, the method return all the
  //days of the month and animate the way to show them
  _buildCalendar() {
    int numberOfWeeks = widget.controller
        .calcNumberOfWeeks(calendarType: widget.controller.calendarType);
    switch (widget.controller.calendarType) {
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

  //This method build the calendar widget, the method check if the column position
  //is according to the number of weeks and set each day on each line
  _buildCalendarContent(int position, int numberOfWeeks) {
    if (position >= widget.controller.checkNumberWeekDay(numberOfWeeks)) {
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
    switch (widget.controller.calendarType) {
      case CalendarType.civilCalendar:
        if (position == (numberOfWeeks - 5)) {
          if (index >= widget.controller.weekDay - 1) {
            int lastDay = 0;
            return _clickableText(
              position: position,
              index: index,
              day: widget.controller.numberOfDays[
                  lastDay + index - widget.controller.weekDay + 2],
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
              day: widget.controller.numberOfDays[
                      lastDay + index - widget.controller.weekDay + 1] +
                  1,
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
              day: widget.controller.numberOfDays[
                  lastDay + index - widget.controller.weekDay + 2],
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
              day: widget.controller.numberOfDays[
                      lastDay + index - widget.controller.weekDay + 1] +
                  1,
            );
          }
        }
        break;
    }
  }

  //This method build the text widget that show tha day, this method also handle the click
  //on each day so it can add or remove the selected day
  _clickableText({
    @required int position,
    @required int index,
    @required int day,
  }) {
    return Container(
        width: 35,
        height: 35,
        child: Obx(
          () => GestureDetector(
            onTap: () {
              setState(() {
                widget.controller.buildDayInset(
                    position, index, day, widget.onDayAddedOrRemoved, context);
              });
            },
            child: Card(
              elevation: 0,
              color: widget.controller.buildCardColor(position, index, day),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              child: Center(
                child: widget.controller.checkEventDate(day, index),
              ),
            ),
          ),
        ));
  }
}
