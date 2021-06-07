# Smart_Calendar
## _Smart_Calendar_

Smart_Calendar is a library that show the calendar, with the possibility of selecting multiples days, change the month or year with simple dynamic.

## Features

- Predefined title widget that returns the calendar month and year.
- Customizable title widget.
- Possibility to change the month with horizontal sliding gesture.
- Brings an extra calendar for the months and year as a cafeteria, which can be reached by clicking on the title widget.
- The user can select multiple days.
- Returns the list of selected dates and returns the current month and year every time it changes.

## New Features
- Now it's possible to add a list of events dates with they title and description, check the example below to know how to do it.
- The list of events can be annual or not.

## Solved
- Solved the bug that was letting select the past dates.

## Attention
- Please use the example below of events dates to add events to your calendar, remember to add all parameters, the day and month are waiting for two digits, so, if the months is 1, then will be 01, the same for the day.

## Easy use
 - First you have to set the controller, where you have to set the initial and last date, the language, the calendar type and weekday type.
```sh
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

- eventDates: This receive a List of events dates with the parameters date, description and title.

- annualEvents: This receive a Boolean to say if the event list is annual or not.

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