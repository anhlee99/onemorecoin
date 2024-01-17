
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateUtils {

  static List<DateTime> getFromToMonth(DateTime dateTime) {
    DateTime start = convertDateTimeDisplay(DateTime(dateTime.year, dateTime.month, 1));
    DateTime end = convertDateTimeFullDay(DateTime(dateTime.year, dateTime.month, getDaysInMonth(dateTime.year, dateTime.month)));
    return [start, end];
  }

  static List<DateTime> getFromToMonthFromString(String dateTime) {
    return getFromToMonth(DateTime.parse(dateTime));
  }

  static List<DateTime> getFromToWeek(DateTime dateTime) {
    DateTime start = convertDateTimeDisplay(dateTime.subtract(Duration(days: dateTime.weekday - 1)));
    DateTime end = convertDateTimeFullDay(dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday)));
    return [start, end];
  }

  static List<DateTime> getFromToWeekFromString(String dateTime) {
    return getFromToWeek(DateTime.parse(dateTime));
  }

  static List<DateTime> getFromToQuarter(DateTime dateTime) {
    DateTime dayStartOfQuarter = dateTime;
    if(dateTime.month % 3 == 0){
      dayStartOfQuarter = DateTime(dateTime.year, dateTime.month - 2, 1);
    }
    if(dateTime.month % 3 == 1){
      dayStartOfQuarter = DateTime(dateTime.year, dateTime.month, 1);
    }
    if(dateTime.month % 3 == 2){
      dayStartOfQuarter = DateTime(dateTime.year, dateTime.month - 1, 1);
    }

    DateTime start = convertDateTimeDisplay(DateTime(dayStartOfQuarter.year, dayStartOfQuarter.month, 1));
    DateTime end = convertDateTimeFullDay(DateTime(dayStartOfQuarter.year, dayStartOfQuarter.month + 3, 0));
    return [start, end];
  }

  static List<DateTime> getFromToQuarterFromString(String dateTime) {
    return getFromToQuarter(DateTime.parse(dateTime));
  }

  static List<DateTime> getFromToYear(DateTime dateTime) {
    DateTime start = convertDateTimeDisplay(DateTime(dateTime.year, 1, 1));
    DateTime end = convertDateTimeFullDay(DateTime(dateTime.year, 12, 31));
    return [start, end];
  }

  static DateTime dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  static int getDateInMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day).day;
  }

  static int getDateInMonthFromString(String dateTime) {
    return DateTime.parse(dateTime).day;
  }

  static String getNameDayOfWeekFromString(String dateTime) {
    return getNameDayOfWeek(DateTime.parse(dateTime));
  }

  static String getMonthAndYearFromString(String dateTime) {
    return getMonthAndYear(DateTime.parse(dateTime));
  }

  static String getMonthAndYear(DateTime dateTime) {
    return "tháng ${dateTime.month} ${dateTime.year}";
  }

  static String toStringFormat00(DateTime dateTime) {
    return "${getNameDayOfWeek(dateTime)}, ${dateTime.day} tháng ${dateTime.month} ${dateTime.year}";
  }

  static String toStringFormat00FromString(String dateTime) {
    return toStringFormat00(DateTime.parse(dateTime));
  }

  static String toStringFormat01(DateTime dateTime) {
    return "${dateTime.day} thg ${dateTime.month} ${dateTime.year}";
  }

  static String toStringFormat01FromString(String dateTime) {
    return toStringFormat01(DateTime.parse(dateTime));
  }

  static String toStringFormat02(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  static String toStringFormat02FromString(String? dateTime) {
    return toStringFormat02(DateTime.parse(dateTime!));
  }

  static String getNameDayOfWeek(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return "Thứ hai";
      case 2:
        return "Thứ ba";
      case 3:
        return "Thứ tư";
      case 4:
        return "Thứ năm";
      case 5:
        return "Thứ sáu";
      case 6:
        return "Thứ bảy";
      case 7:
        return "Chủ nhật";
    }
    return "";
  }

  static bool isBetween(DateTime dateTime, DateTime start, DateTime end) {
    return dateTime.isAfter(start.subtract( const Duration(seconds: 1))) && dateTime.isBefore(end);
  }

  static bool isBetweenDateOnly(DateTime dateTime, DateTime start, DateTime end) {
    return dateOnly(dateTime).isAfter(dateOnly(start).subtract( const Duration(seconds: 1))) && dateOnly(dateTime).isBefore(dateOnly(end));
  }

  static bool isAfterDateOnly(DateTime dateTime, DateTime start) {
    return dateOnly(dateTime).isAfter(dateOnly(start));
  }

  static bool isAfter(DateTime dateTime, DateTime start) {
    return dateTime.isAfter(start.subtract( const Duration(seconds: 1)));
  }

  static bool isBefore(DateTime dateTime, DateTime end) {
    return dateTime.isBefore(end.add(Duration(seconds: 1)));
  }

  static bool isBeforeDateOnly(DateTime dateTime, DateTime end) {
    return dateOnly(dateTime).isBefore(dateOnly(end));
  }

  static String parseTypeToString(String? budgetType) {
    switch (budgetType) {
      case "week":
        return "Tuần";
      case "month":
        return "Tháng";
      case "quarter":
        return "Quý";
      case "year":
        return "Năm";
    }
    return "";
  }

  static DateTime convertDateTimeDisplay(DateTime date) {
    return DateUtils.dateOnly(date);
  }

  static DateTime convertDateTimeFullDay(DateTime date) {
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final String formatted = serverFormater.format(date);
    DateTime dateTime = serverFormater.parse(formatted)
        .add(const Duration(hours: 23))
        .add(const Duration(minutes: 59))
        .add(const Duration(seconds: 59));
    return dateTime;
  }

  static Duration getDuration(DateTime start, DateTime end) {
    return end.difference(start);
  }

  static String getDurationString(DateTime start, DateTime end) {
    Duration duration = getDuration(start, end);
    return "${duration.inHours} giờ ${duration.inMinutes.remainder(60)} phút";
  }

  static String subtractTimeToDay(DateTime start, DateTime end) {
    final Duration duration = getDuration(start, end);
    if(duration.inDays == 0){
      return "${duration.inHours} giờ";
    }
    return "${duration.inDays} ngày";
  }

  static int parseBudgetTypeToDay(String s) {
    switch (s) {
      case "week":
        return 6;
      case "month":
        return 30;
      case "quarter":
        return 90;
      case "year":
        return 365;
    }
    return 0;
  }

  static isSameDate(DateTime dateTime, DateTime parse) {
    return dateTime.year == parse.year && dateTime.month == parse.month && dateTime.day == parse.day;
  }
}