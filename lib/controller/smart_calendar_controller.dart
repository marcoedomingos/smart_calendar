import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum WeekDayType {
  short,
  medium,
  long,
}

enum CalendarType {
  civilCalendar,
  notCivilCalendar,
}

enum ExtraCalendarType {
  alertDialogType,
  snackBarType,
}

class SmartCalendarController extends GetxController implements ChangeNotifier {
  SmartCalendarController({
    @required this.initialDate,
    @required this.lastDate,
    @required this.eventDates,
    @required this.annualEvents,
    @required this.locale,
    @required this.calendarType,
    @required this.weekdayType,
  });

  final DateTime initialDate;
  final DateTime lastDate;
  final List eventDates;
  final bool annualEvents;
  final String locale;
  final CalendarType calendarType;
  final WeekDayType weekdayType;
  final _numberOfDays = [].obs;
  final _currentYear = 0.obs;
  final _currentMonth = 0.obs;
  final _weekDay = 0.obs;
  final _weekSize = 0.obs;
  final _daysOfTheWeek = [].obs;
  final _months = [].obs;
  final _selectedDays = [].obs;

  get numberOfDays => this._numberOfDays;

  set numberOfDays(value) => this._numberOfDays.value = value;

  get currentYear => this._currentYear.value;

  set currentYear(value) => this._currentYear.value = value;

  get currentMonth => this._currentMonth.value;

  set currentMonth(value) => this._currentMonth.value = value;

  get weekDay => this._weekDay.value;

  set weekDay(value) => this._weekDay.value = value;

  get weekSize => this._weekSize.value;

  set weekSize(value) => this._weekSize.value = value;

  get selectedDays => this._selectedDays;

  set selectedDays(value) => this._selectedDays.value = value;

  get daysOfTheWeek => this._daysOfTheWeek;

  set daysOfTheWeek(value) => this._daysOfTheWeek.value = value;

  get months => this._months;

  set months(value) => this._months.value = value;

  //This method check the number of weekDays to return the exact total
  //so the widget may get exact position for each week
  checkNumberWeekDay(int numberOfWeeks) {
    if (weekDay == 8) {
      return (numberOfWeeks - weekSize) + 2;
    } else {
      return (numberOfWeeks - weekSize) + 1;
    }
  }

  //This method is responsible to add or remove the day if the user click on the day, the
  //method check if the clicked day is higher that the initial date, if it's then
  //the process continue, if not, nothing happens, it also check if the date have
  //an event, if true, then will show a snackbar asking to add or remove the date
  //the method check is the date is equal to any of the date that is save on
  //the list, if there is any match, the day is removed from the list, if
  //not, the day is added to the list, the method also return the
  //function with the date clicked and the list of dates
  buildDayInset(int position, int index, int day, Function function,
      BuildContext context) {
    String month = currentMonth < 10 ? "0$currentMonth" : "$currentMonth";
    String dayClicked = day < 10 ? "0$day" : "$day";
    String currentDate = "$currentYear-$month-$dayClicked";
    if (initialDate.isBefore(DateTime.parse(currentDate))) {
      List events = List.from(eventDates);
      var selectedDay = day < 10 ? "0$day" : "$day";
      String month = currentMonth < 10 ? "0$currentMonth" : "$currentMonth";
      String fullDate = "$currentYear-$month-$selectedDay";
      events.removeWhere((element) => element['date'] != fullDate);
      if (events.length > 0) {
        List size = List.from(selectedDays);
        bool remove = false;
        size.removeWhere((element) => element['year'] != currentYear);
        if (size.length > 0) {
          size.removeWhere((element) => element['month'] != currentMonth);
          if (size.length > 0) {
            size.removeWhere((element) => element['day'] != day);
            if (size.length > 0) {
              remove = true;
            }
          }
        }

        var snackBar = SnackBar(
          duration: Duration(days: 1),
          content: Container(
            width: Get.width,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        events[0]['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        width: Get.width / 2,
                        child: Text(
                          events[0]['description'],
                          style: TextStyle(
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (remove == true) {
                        selectedDays.removeWhere((element) =>
                            element['year'] == currentYear &&
                            element['month'] == currentMonth &&
                            element['day'] == day);
                        buildCardColor(position, index, day);
                        notifyListeners();
                      } else {
                        selectedDays.add({
                          'day': day,
                          'month': currentMonth,
                          'year': currentYear
                        });
                        buildCardColor(position, index, day);
                        notifyListeners();
                      }
                      if (function != null) {
                        function(
                            day,
                            currentMonth,
                            months[currentMonth - 1].toString().capitalizeFirst,
                            currentYear,
                            selectedDays);
                      }
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: Card(
                        color: remove == true ? Colors.red : Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                            left: 12.0,
                            right: 12.0,
                          ),
                          child: Text(
                            remove == true ? " - " : "+",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ],
              )
            ]),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        List size = List.from(selectedDays);
        bool remove = false;
        size.removeWhere((element) => element['year'] != currentYear);
        if (size.length > 0) {
          size.removeWhere((element) => element['month'] != currentMonth);
          if (size.length > 0) {
            size.removeWhere((element) => element['day'] != day);
            if (size.length > 0) {
              remove = true;
            }
          }
        }
        if (remove == true) {
          selectedDays.removeWhere((element) =>
              element['year'] == currentYear &&
              element['month'] == currentMonth &&
              element['day'] == day);
          buildCardColor(position, index, day);
          notifyListeners();
        } else {
          selectedDays
              .add({'day': day, 'month': currentMonth, 'year': currentYear});
          buildCardColor(position, index, day);
          notifyListeners();
        }
        if (function != null) {
          function(
              day,
              currentMonth,
              months[currentMonth - 1].toString().capitalizeFirst,
              currentYear,
              selectedDays);
        }
      }
    }
  }

  //This method has a similar functionality as the buildDayInset() method,
  //the process is the same the difference is that this method only
  //change color of the days that where inserted ont the date list
  Color buildCardColor(int position, int index, int day) {
    List size = List.from(selectedDays);
    bool add = false;
    size.removeWhere((element) => element['year'] != currentYear);
    if (size.length > 0) {
      size.removeWhere((element) => element['month'] != currentMonth);
      if (size.length > 0) {
        size.removeWhere((element) => element['day'] != day);
        if (size.length > 0) {
          add = true;
        }
      }
    }
    if (add == true) {
      return Colors.red;
    } else {
      return Colors.transparent;
    }
  }

  //This method is responsible to check the weekends according to the type of calendar
  //inserted, if the day is a weekend, the method return the color Grey,
  //if not, the method return the default color Black
  buildWeekendColor(int index) {
    switch (calendarType) {
      case CalendarType.civilCalendar:
        if (index >= 5) {
          return Colors.grey;
        } else {
          return Colors.black;
        }
        break;
      case CalendarType.notCivilCalendar:
        if (index == 0) {
          return Colors.grey;
        } else if (index == 6) {
          return Colors.grey;
        } else {
          return Colors.black;
        }
        break;
    }
  }

  //This method is responsible to get the total of weeks so the buidCalendar() method
  //may get the exact number to each position get the right week, still depending
  //on the type of calendar inserted
  calcNumberOfWeeks({@required CalendarType calendarType}) {
    var result = 0;
    switch (calendarType) {
      case CalendarType.civilCalendar:
        weekSize = 6;
        result = weekDay + weekSize;
        break;
      case CalendarType.notCivilCalendar:
        weekSize = 7;
        result = weekDay + weekSize;
        break;
    }

    return result;
  }

  //This method is responsible to calculate the exact number of days
  //each month have, get the weekday of first day of each month,
  //still depending on the type of calendar insert
  calcNumberOfDays({Function function}) {
    switch (calendarType) {
      case CalendarType.civilCalendar:
        DateTime firstDate;
        numberOfDays.clear();
        if (currentYear == 0) {
          firstDate = DateTime(initialDate.year, initialDate.month);
          currentYear = initialDate.year;
          currentMonth = initialDate.month;
        } else {
          firstDate = DateTime(currentYear, currentMonth);
        }
        int finalDay = DateTime(firstDate.year, firstDate.month + 1, 0).day;
        weekDay = firstDate.weekday;
        if (numberOfDays.length < 1) {
          for (int i = 0; i < finalDay + 1; i++) {
            numberOfDays.add(i);
          }
        }
        break;

      case CalendarType.notCivilCalendar:
        DateTime firstDate;
        numberOfDays.clear();
        if (currentYear == 0) {
          firstDate = DateTime(initialDate.year, initialDate.month);
          currentYear = initialDate.year;
          currentMonth = initialDate.month;
        } else {
          firstDate = DateTime(currentYear, currentMonth);
        }
        int finalDay = DateTime(firstDate.year, firstDate.month + 1, 0).day;
        weekDay = firstDate.weekday + 1;
        if (numberOfDays.length < 1) {
          for (int i = 0; i < finalDay + 1; i++) {
            numberOfDays.add(i);
          }
        }
        break;
    }
    if (function != null) {
      function(
          months[currentMonth - 1].toString().capitalizeFirst, currentYear);
    }
  }

  //This method is responsible to check if the date that
  //is showing const as an event on the event list and
  //check if an annual event
  checkEventDate(int day, int index) {
    print(eventDates.length);
    if (annualEvents == false) {
      List events = List.from(eventDates);
      var selectedDay = day < 10 ? "0$day" : "$day";
      String month = currentMonth < 10 ? "0$currentMonth" : "$currentMonth";
      String fullDate = "$currentYear-$month-$selectedDay";
      events.removeWhere((element) => element['date'] != fullDate);
      if (events.length > 0) {
        return Text(
          day.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        return Text(
          day.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(color: buildWeekendColor(index)),
        );
      }
    } else {
      List events = List.from(eventDates);
      var selectedDay = day < 10 ? "0$day" : "$day";
      String month = currentMonth < 10 ? "0$currentMonth" : "$currentMonth";
      String fullDate = "$month-$selectedDay";
      events.removeWhere((element) =>
          element['date']
              .toString()
              .substring(5, element['date'].toString().length) !=
          fullDate);
      if (events.length > 0) {
        return Text(
          day.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        return Text(
          day.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(color: buildWeekendColor(index)),
        );
      }
    }
  }

  //This method is responsible to go to the previous month and return the
  //function that say the exact month and year is current be showing
  goBackWard({@required Function function}) {
    if (currentYear >= initialDate.year) {
      if (currentYear == initialDate.year) {
        if (currentMonth > initialDate.month) {
          currentMonth = currentMonth - 1;
          calcNumberOfDays();
        }
      } else {
        if (currentMonth > 1) {
          currentMonth = currentMonth - 1;
          calcNumberOfDays();
        } else {
          currentYear = currentYear - 1;
          currentMonth = 12;
          calcNumberOfDays();
        }
      }
    }
    if (function != null) {
      function(
          months[currentMonth - 1].toString().capitalizeFirst, currentYear);
    }
  }

  //This method is responsible to go to the next month and return the
  //function that say the exact month and year is current be showing
  goForWard({@required Function function}) {
    if (currentYear <= lastDate.year) {
      if (currentYear == lastDate.year) {
        if (currentMonth < lastDate.month) {
          currentMonth = currentMonth + 1;
          calcNumberOfDays();
        }
      } else {
        if (currentMonth < 12) {
          currentMonth = currentMonth + 1;
          calcNumberOfDays();
        } else {
          currentYear = currentYear + 1;
          currentMonth = 1;
          calcNumberOfDays();
        }
      }
    }
    if (function != null) {
      function(
          months[currentMonth - 1].toString().capitalizeFirst, currentYear);
    }
  }

  //This method is responsible to go to the previous year and return the
  //function that say the exact month and year is current be showing
  goBackWardInYear({@required Function function}) {
    if (currentYear >= initialDate.year) {
      if (currentYear > initialDate.year) {
        currentYear = currentYear - 1;
        currentMonth = initialDate.month;
        calcNumberOfDays();
      } else {
        currentMonth = initialDate.month;
        calcNumberOfDays();
      }
    }
    if (function != null) {
      function(
          months[currentMonth - 1].toString().capitalizeFirst, currentYear);
    }
  }

  //This method is responsible to go to the next year and return the
  //function that say the exact month and year is current be showing
  goForWardInYear({@required Function function}) {
    if (currentYear <= lastDate.year) {
      if (currentYear < lastDate.year) {
        currentYear = currentYear + 1;
        currentMonth = initialDate.month;
        calcNumberOfDays();
      }
    }
    if (function != null) {
      function(
          months[currentMonth - 1].toString().capitalizeFirst, currentYear);
    }
  }

  //This method is responsible of calculate the exact difference
  //between the initial year and last year inserted so it may
  //build the _buildYearCalendar() widget
  getDifferenceBetweenYears() {
    int total = (lastDate.year - initialDate.year) + 1;
    return total;
  }

  @override
  notifyListeners() {
    return ChangeNotifier().notifyListeners();
  }
}
