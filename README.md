# Smart_Calendar
## _Smart_Calendar_

Smart_Calendar is a widget that show the calendar, with the possibility of selecting multiples days, change the month or year with simple dynamic.

## Features

- Predefined title widget that returns the calendar month and year.
- Customizable title widget.
- Possibility to change the month with horizontal sliding gesture.
- Brings an extra calendar for the months and year as a cafeteria, which can be reached by clicking on the title widget.
- The user can select multiple days.
- Returns the list of selected dates and returns the current month and year every time it changes.

## Easy use
 - First you have to set the controller, where you have to set the initial and last date, the language, the calendar type and weekday type.
```sh
final controller = SmartCalendarController(
    initialDate: DateTime.now(),
    lastDate: DateTime.utc(2053, 04, 31),
        locale: 'pt_BR',
    calendarType: CalendarType.notCivilCalendar,
    weekdayType: WeekDayType.medium,
  );
```
 - After this you can call the class and add the functions that you want to return.
```sh
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
                )
```

## The Controller Parameters
- initialDate: This receive a DateTime that you want to be the initial date.

- lastDate: This receive a DateTime that you want to be the last date.

- locale: This receive a String that will be locale for the intl get the exact translantion of thes month and weekdays.

- calendarType: This parementer can receive CalendarType.civilCalendar or CalendarType.notCivilCalendar. If you select civiCalendart, the week will start on Monday, but if you select notCivilCalendar, then will start with on a Sunday.
- 
- weekdayType: This paramenter can receive WeekDayType.short, WeekDayType.medium and WeekDayType.long. If you select short, then the weekday will show only the first letter, if you select medium, then the weekday will show only the 3 letters and if you select long, then the weekday will show the full name.

## SmartCalendar Parameters
- controller: This receive the controller that you initialized before.

- onBackwardOrForward: This receive a function so it may retrieve the month and year when gobackwar or forward on the month or year.

- onDayAddedOrRemoved: This receive a function so it may retrieve the day, month, monthName, year or list of date when a day is added or removed.

## Images of the library on use
 - This is smart Calendar with the default title widget
![Image 1](https://i.ibb.co/G9yYPsT/Whats-App-Image-2021-05-09-at-19-15-08.jpg)

 - This is Smart Calendar with the customizable title widget
![Image 2](https://i.ibb.co/FKMksbs/Whats-App-Image-2021-05-09-at-19-15-08-4.jpg)

 - This is smart Calendar with multiple days selected
![Image 3](https://i.ibb.co/ZYT04hr/Whats-App-Image-2021-05-09-at-19-15-08-2.jpg)

 - This is Smart Calendar with the extra year calendar showing
![Image 4](https://i.ibb.co/myj7pk5/Whats-App-Image-2021-05-09-at-19-15-08-3.jpg)

 - This is Smart Calendar with the extra month calendar showing
![Image 5](https://i.ibb.co/k8yzJhk/Whats-App-Image-2021-05-09-at-19-15-08-5.jpg)

 - This is Smart Calendar with calendartype as civilCalendar
![Image 6](https://i.ibb.co/YdK3zPh/Whats-App-Image-2021-05-09-at-19-15-08-7.jpg)

 - This is Smart Calendar with calendartype as notCivilCalendar
![Image 7](https://i.ibb.co/FKMksbs/Whats-App-Image-2021-05-09-at-19-15-08-4.jpg)

## Installation

Install the dependencies.

```sh
flutter pub get add smart_calendart
```

The library was completely made with dart and is still under development, hope this library can help you the same way is helping me. Here is the link to [Github](https://github.com/Marco4763/smart_calendar/blob/master/example/lib/main.dart) - Project example.