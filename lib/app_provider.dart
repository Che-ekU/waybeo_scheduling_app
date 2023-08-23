import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  List<String> selectedTile = [];
  List<DaySchedule> days = [
    DaySchedule(title: 'MON', availableTime: [], fullTitle: 'Monday'),
    DaySchedule(title: 'TUE', availableTime: [], fullTitle: 'Tuesday'),
    DaySchedule(title: 'WED', availableTime: [], fullTitle: 'Wednesday'),
    DaySchedule(title: 'THU', availableTime: [], fullTitle: 'Thursday'),
    DaySchedule(title: 'FRI', availableTime: [], fullTitle: 'Friday'),
    DaySchedule(title: 'SAT', availableTime: [], fullTitle: 'Saturday'),
    DaySchedule(title: 'SUN', availableTime: [], fullTitle: 'Sunday'),
  ];
  void notify() => notifyListeners();

  TextEditingController textEditingController = TextEditingController();

  String getAvailableTime() {
    String availableTime = 'Hi Jose you are available in ';
    for (DaySchedule e in days) {
      if (e.availableTime.isNotEmpty) {
        if (days.indexOf(e) == days.length - 1 ||
            (days.lastIndexWhere(
                        (element) => element.availableTime.isNotEmpty) ==
                    days.indexOf(e) &&
                selectedTile.indexOf(e.title) != 0)) {
          if (days.length != 1) {
            availableTime =
                availableTime.substring(0, availableTime.length - 2);
          }
          availableTime += ' and ${e.fullTitle} ';
        } else {
          availableTime += '${e.fullTitle} ';
        }
        for (String i in e.availableTime) {
          if (e.availableTime.length == 3) {
            availableTime += 'whole day, ';
            break;
          } else if (days.indexOf(e) == days.length - 2) {
            availableTime += '$i, ';
          } else {
            availableTime += '$i, ';
          }
        }
      }
    }
    return '${availableTime.substring(0, availableTime.length - 2)}.';
  }
}

class DaySchedule {
  DaySchedule({
    required this.title,
    required this.availableTime,
    required this.fullTitle,
  });
  List<String> availableTime;
  String title;
  String fullTitle;
}
