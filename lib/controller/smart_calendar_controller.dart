import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_calendar/smart_calendar.dart';

class SmartCalendarController extends GetxController implements ChangeNotifier {
  final _numberOfDays = [].obs;
  final _currentYear = 0.obs;
  final _currentMonth = 0.obs;
  final _weekDay = 0.obs;
  final _weekSize = 0.obs;
  final _daysOfTheWeek = [].obs;
  final _months = [].obs;
  final _selectedDays = [].obs;

  get numberOfDays => this._numberOfDays.value;

  set numberOfDays(value) => this._numberOfDays.value = value;

  get currentYear => this._currentYear.value;

  set currentYear(value) => this._currentYear.value = value;

  get currentMonth => this._currentMonth.value;

  set currentMonth(value) => this._currentMonth.value = value;

  get weekDay => this._weekDay.value;

  set weekDay(value) => this._weekDay.value = value;

  get weekSize => this._weekSize.value;

  set weekSize(value) => this._weekSize.value = value;

  get selectedDays => this._selectedDays.value;

  set selectedDays(value) => this._selectedDays.value = value;

  get daysOfTheWeek => this._daysOfTheWeek.value;

  set daysOfTheWeek(value) => this._daysOfTheWeek.value = value;

  get months => this._months.value;

  set months(value) => this._months.value = value;

  checkWeekDay(int numberOfWeeks){
    if(weekDay == 8){
      return (numberOfWeeks - weekSize) +2;
    }else{
      return (numberOfWeeks - weekSize) +1;
    }
  }

  buildDayInset(int position, int index, int day, Function function) {
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
      selectedDays.removeWhere((element) => element['year'] == currentYear && element['month'] == currentMonth && element['day'] == day);
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
    function(day, currentMonth, months[currentMonth - 1].toString().capitalizeFirst, currentYear, selectedDays);
  }

  buildCardColor(int position, int index, int day) {
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

  calcNumberOfDays(
      {@required CalendarType calendarType, @required DateTime initialDate}) {
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
  }

  goBackWard({
    @required CalendarType calendarType,
    @required DateTime initialDate,
    @required Function function,
  }) {
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
    function(months[currentMonth - 1].toString().capitalizeFirst, currentYear);
  }

  goForWard({
    @required CalendarType calendarType,
    @required DateTime lastDate,
    @required Function function,
  }) {
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
    function(months[currentMonth - 1].toString().capitalizeFirst, currentYear);
  }

  @override
  notifyListeners() {
    return ChangeNotifier().notifyListeners();
  }
}
