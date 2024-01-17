import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onemorecoin/model/BudgetModel.dart';
import 'package:onemorecoin/model/TransactionModel.dart';
import 'package:onemorecoin/utils/MyDateUtils.dart';
import '../Objects/ShowType.dart';
import '../Objects/TabTransaction.dart';

class Utils {


  static List<TabTransaction> getListTabShowTypeTransaction(ShowType showType, int totalTab)  {
    List<TabTransaction> listTab = [];
    switch (showType) {
      case ShowType.date:
        listTab = Utils.getListDateBackToNow(totalTab);
        for(int i = 0; i < listTab.length; i++){
          if(i == totalTab - 1){
            listTab[i].name = "HÔM QUA";
          }
          if(i == totalTab){
            listTab[i].name = "HÔM NAY";
          }
        }
        listTab.add(TabTransaction("TƯƠNG LAI", listTab.last.to.add(const Duration(seconds: 1)), listTab.last.to.add(const Duration(seconds: 1)))..isFuture = true);
        break;
      case ShowType.week:
        listTab = Utils.getListWeekBackToNow(totalTab);
        for(int i = 0; i < listTab.length; i++){
          if(i == totalTab - 1){
            listTab[i].name = "TUẦN TRƯỚC";
          }
          if(i == totalTab){
            listTab[i].name = "TUẦN NÀY";
          }
        }
        listTab.add(TabTransaction("TƯƠNG LAI", listTab.last.to.subtract(const Duration(seconds: 1)), listTab.last.to.add(const Duration(seconds: 7)))..isFuture = true);
        break;
      case ShowType.month:
        listTab = Utils.getListMonthBackToNow(totalTab);

        for(int i = 0; i < listTab.length; i++){
          if(i == totalTab - 1){
            listTab[i].name = "THÁNG TRƯỚC";
          }
          if(i == totalTab){
            listTab[i].name = "THÁNG NÀY";
          }
        }
        listTab.add(TabTransaction("TƯƠNG LAI", listTab.last.to.add(const Duration(seconds: 1)), listTab.last.to.add(const Duration(seconds: 1)))..isFuture = true);
         break;
      case ShowType.quarter:
        listTab = Utils.getListQuarterBackToNow(totalTab);
        listTab.add(TabTransaction("TƯƠNG LAI", listTab.last.to.add(const Duration(seconds: 1)), listTab.last.to.add(const Duration(seconds: 1)))..isFuture = true);
        break;
      case ShowType.year:
        listTab = Utils.getListYearBackToNow(totalTab);
        for(int i = 0; i < listTab.length; i++){
          if(i == totalTab - 1){
            listTab[i].name = "NĂM TRƯỚC";
          }
          if(i == totalTab){
            listTab[i].name = "NĂM NÀY";
          }
        }
        listTab.add(TabTransaction("TƯƠNG LAI", listTab.last.to.add(const Duration(seconds: 1)), listTab.last.to.add(const Duration(seconds: 1)))..isFuture = true);
        break;
      case ShowType.all:
        TabTransaction tab = TabTransaction("TẤT CẢ GIAO DỊCH", DateTime(2000, 1, 1), DateTime.now());
        tab.isAll = true;
        listTab.add(tab);
        break;
      // case ShowType.option:
      //   listTab.add("TẤT CẢ GIAO DỊCH");
      //   break;
        // TODO: Handle this case.
      case ShowType.option:
        // TODO: Handle this case.
    }
    return listTab;
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

  static String dateToString(DateTime dateTime){
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  static List<TabTransaction> getListDateBackToNow(int number){
    List<TabTransaction> list = [];
    DateTime now = DateTime.now();
    while(number >= 0){
      DateTime day = now.subtract(Duration(days: number));
      list.add(TabTransaction("${day.day}/${day.month}/${day.year}", convertDateTimeDisplay(day), convertDateTimeFullDay(day)));
      number--;
    }
    return list;
  }

  static List<TabTransaction> getListWeekBackToNow(int number){
    List<TabTransaction> list = [];
    DateTime now = DateTime.now();
    DateTime dayEndWeed = now.add(Duration(days: (DateTime.daysPerWeek - now.weekday - 7)));
    while(number >= 0){
      DateTime start = dayEndWeed.subtract(Duration(days: number * DateTime.daysPerWeek - 1 ));
      DateTime end = start.add(const Duration(days: DateTime.daysPerWeek - 1));
      list.add(TabTransaction("${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}", convertDateTimeDisplay(start), convertDateTimeFullDay(end)));
      number--;
    }
    return list;
  }

  static List<TabTransaction> getListMonthBackToNow(int number){
    List<TabTransaction> list = [];
    DateTime now = DateTime.now();
    DateTime monthStart = DateTime(now.year, now.month, 1);
    while(number >= 0){
      DateTime start = DateTime(monthStart.year, monthStart.month - number, 1);
      list.add(TabTransaction("${start.month}/${start.year}", convertDateTimeDisplay(start), convertDateTimeFullDay(DateTime(start.year, start.month, 1).add(Duration(days: DateUtils.getDaysInMonth(start.year, start.month) - 1)))));
      number--;
    }
    return list;
  }

  static List<TabTransaction> getListQuarterBackToNow(int number){
    List<TabTransaction> list = [];
    DateTime now = DateTime.now();
    DateTime dayStartOfQuarter = now;
    if(now.month % 3 == 0){
      dayStartOfQuarter = DateTime(now.year, now.month - 2, 1);
    }
    if(now.month % 3 == 1){
      dayStartOfQuarter = DateTime(now.year, now.month, 1);
    }
    if(now.month % 3 == 2){
      dayStartOfQuarter = DateTime(now.year, now.month - 1, 1);
    }
    while(number >= 0){
      DateTime start = DateTime(dayStartOfQuarter.year , dayStartOfQuarter.month - number * 3 , 1);
      DateTime end = DateTime(start.year , start.month + 2 , 1);

      list.add(TabTransaction("Q${(start.month / 3).ceil() }/${start.year}", convertDateTimeDisplay(start), convertDateTimeFullDay(end.add(Duration(days: DateUtils.getDaysInMonth(end.year, end.month) - 1)))));
      number--;
    }
    return list;
  }

  static List<TabTransaction> getListYearBackToNow(int number){
    List<TabTransaction> list = [];
    DateTime now = DateTime.now();
    while(number >= 0){
      DateTime start = DateTime(now.year - number, 1 , 1);
      DateTime end = DateTime(now.year - number, 12 , 1).add(Duration(days: DateUtils.getDaysInMonth(start.year, 12) - 1));

      list.add(TabTransaction("${start.year}", convertDateTimeDisplay(start), convertDateTimeFullDay(end)));
      number--;
    }
    return list;
  }

  static String getStringFormatDayOfWeek(DateTime dateTime){
    if(dateTime.weekday == DateTime.monday){
      return "Thứ hai, ${dateTime.day} tháng ${dateTime.month} ${dateTime.year}";
    }
    if(dateTime.weekday == DateTime.tuesday){
      return "Thứ ba, ${dateTime.day} tháng ${dateTime.month} ${dateTime.year}";
    }
    if(dateTime.weekday == DateTime.wednesday){
      return "Thứ tư, ${dateTime.day} tháng ${dateTime.month} ${dateTime.year}";
    }
    if(dateTime.weekday == DateTime.thursday){
      return "Thứ năm, ${dateTime.day} tháng ${dateTime.month} ${dateTime.year}";
    }
    if(dateTime.weekday == DateTime.friday){
      return "Thứ sáu, ${dateTime.day} tháng ${dateTime.month} ${dateTime.year}";
    }
    if(dateTime.weekday == DateTime.saturday){
      return "Thứ bảy, ${dateTime.day} tháng ${dateTime.month} ${dateTime.year}";
    }
    if(dateTime.weekday == DateTime.sunday){
      return "Chủ nhật, ${dateTime.day} tháng ${dateTime.month} ${dateTime.year}";
    }
    return "Thứ ${dateTime.weekday + 1}, ${dateTime.day} tháng ${dateTime.month} ${dateTime.year}";
  }

  static String getStringFormatDateAndTime(DateTime dateTime){
    return "${dateTime.day} tháng ${dateTime.month} ${dateTime.year} - ${dateTime.hour}:${dateTime.minute}";
  }

  static double sumAmountTransaction(List<TransactionModel> transactionModels){
    double sum = 0;
    for(TransactionModel transactionModel in transactionModels){
      if(transactionModel.type == "expense"){
        sum -= transactionModel.amount!;
      }
      else{
        sum += transactionModel.amount!;
      }
    }
    return sum;
  }

  static double sumExpenseAmountTransaction(List<TransactionModel> transactionModels){
    double sum = 0;
    for(TransactionModel transactionModel in transactionModels){
      if(transactionModel.type == "expense"){
        sum += transactionModel.amount!;
      }
    }
    return sum;
  }


  static double sumAmountTransactionToDate(List<TransactionModel> transactionModels, DateTime dateTime){
    double sum = 0;
    for(TransactionModel transactionModel in transactionModels){
      if(transactionModel.type == "expense" && MyDateUtils.isBefore(DateTime.parse(transactionModel.date!), dateTime)){
        sum -= transactionModel.amount!;
      }
      else if(transactionModel.type == "income" && MyDateUtils.isBefore(DateTime.parse(transactionModel.date!), dateTime)){
        sum += transactionModel.amount!;
      }
    }
    return sum;
  }

  static double sumBudget(List<BudgetModel> budgetModels){
    double sum = 0;
    for(BudgetModel budgetModel in budgetModels){
      sum += budgetModel.budget!;
    }
    return sum;
  }

  static double sumBudgetAmountTransaction(List<BudgetModel> budgetModels){
    double sum = 0;
    for(BudgetModel budgetModel in budgetModels){
      sum += sumAmountTransaction(budgetModel.transactions);
    }
    return sum;
  }

  static String currencyFormat(double amount) {
    String result =  NumberFormat.currency(customPattern: '###,###', symbol: "", decimalDigits: 0).format(amount);
    return result;
  }

  static double unCurrencyFormat(String amount) {
    String result = amount.replaceAll(",", "");
    return double.parse(result);
  }

}