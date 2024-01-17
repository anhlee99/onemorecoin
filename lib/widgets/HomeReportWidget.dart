import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onemorecoin/model/GroupModel.dart';
import 'package:provider/provider.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Objects/ShowType.dart';
import '../Objects/TabTransaction.dart';
import '../commons/Constants.dart';
import '../model/TransactionModel.dart';
import '../utils/MyDateUtils.dart';
import '../utils/Utils.dart';

class HomeReportWidget extends StatefulWidget {

  const HomeReportWidget({super.key,
  });

  @override
  State<HomeReportWidget> createState() => _HomeReportWidgetState();
}

class _HomeReportWidgetState extends State<HomeReportWidget> {
  int chartType = 0;
  List<TabTransaction> listTab = [];
  int totalTab = 20;
  double totalSpent = 0;
  List<ChartData> chartData = [];
  Map<GroupModel, double> mostGroupExpense = {};
  int limitMostGroupExpense = 3;
  double percent = 0;
  List<TransactionModel> transactions = [];

  @override
  void initState() {
    super.initState();
    List<TabTransaction> ls = Utils.getListTabShowTypeTransaction(ShowType.week, totalTab);
    // ls.removeLast();
    listTab = [ls[ls.length - 3], ls[ls.length - 2]];

  }

  void _generateListTab(int index){
    if (index == 0) {
      List<TabTransaction> ls = Utils.getListTabShowTypeTransaction(ShowType.week, totalTab);
      // ls.removeLast();
      ls = [ls[ls.length - 3], ls[ls.length - 2]];
      setState(() {
        chartType = 0;
        listTab = ls;
        // chartData = _generateChartData(transactions);
      });
    }

    if(index == 1){
      List<TabTransaction> ls = Utils.getListTabShowTypeTransaction(ShowType.month, totalTab);
      // ls.removeLast();
      ls = [ls[ls.length - 3], ls[ls.length - 2]];
      setState(() {
        chartType = 1;
        listTab = ls;
        // chartData = _generateChartData(transactions);
      });
    }

  }

  _generateChartData(List<TransactionModel> transactions ) {
    mostGroupExpense = {};
    for (final item in listTab) {
      item.transactions.clear();
    }
    transLoop:
    for(var tran in transactions){
      tabLoop:
      for(var tab in listTab){
        if(tab.isAll){
          tab.transactions.add(tran);
          break tabLoop;
        }
        if(tab.isFuture){
          if(MyDateUtils.isAfter(DateTime.parse(tran.date!), tab.from)){
            tab.transactions.add(tran);
            break tabLoop;
          }
        }
        else{
          if(MyDateUtils.isBetween(DateTime.parse(tran.date!), tab.from, tab.to)){
            tab.transactions.add(tran);
            break tabLoop;
          }
        }
      }
    }

    List<ChartData> chartData = [];
    for (final tab in listTab) {
      double expense = 0;
      double income = 0;
      for(final item in tab.transactions){
        if(item.type == "expense"){
          expense += item.amount!;
        }else{
          income += item.amount!;
        }
      }
      chartData.add(ChartData(tab.name, expense, income));
    }

    ////// tìm nhóm chi nhiều nhất //////
    Map<int, double> mostExpenseByGroup = {};
    for(final item in listTab.last.transactions){
      if(item.type == "expense"){
        if(mostExpenseByGroup.containsKey(item.groupId)){
          mostExpenseByGroup[item.groupId] = mostExpenseByGroup[item.groupId]! + item.amount!;
        }
        else{
          mostExpenseByGroup[item.groupId] = item.amount!;
        }
      }
    }
    mostExpenseByGroup = Map.fromEntries(
        mostExpenseByGroup.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));

    if(mostExpenseByGroup.isNotEmpty){
      for(final key in mostExpenseByGroup.keys){
        if(mostGroupExpense.length == limitMostGroupExpense){
          break;
        }
        mostGroupExpense[context.read<GroupModelProxy>().getById(key)] = mostExpenseByGroup[key]!;
      }
    }
    /////////////////////////////////////////////

    totalSpent = chartData.last.expense;
    if(chartData[chartData.length - 2].expense == 0){
      percent = 100;
    }else{
      percent = double.parse(((chartData.last.expense - chartData[chartData.length - 2].expense) / chartData[chartData.length - 2].expense).toStringAsFixed(3)) * 100;
    }
    return chartData.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    transactions = context.watch<TransactionModelProxy>().transactionModels;
    chartData = _generateChartData(transactions);

    return Container(
      margin: const EdgeInsets.symmetric( horizontal: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SlideSwitcher(
                  onSelect: (int index) => _generateListTab(index),
                  containerColor: Colors.grey[200]!,
                  slidersColors: [Colors.white],
                  containerBorderRadius: 5,
                  indents: 3,
                  containerHeight: 30,
                  containerWight: constraints.maxWidth - 60,
                  children: [
                    Text("Tuần",
                      style: TextStyle(
                        color: chartType == 0 ? Colors.black : Colors.grey,
                      ),
                    ),
                    Text("Tháng",
                      style: TextStyle(
                        color: chartType == 1 ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                );
              }
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utils.currencyFormat(totalSpent),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text("Tổng đã chi ${chartType == 0 ? "tuần" : "tháng" } này",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                        child: percent < 0 ?
                            Icon(Icons.arrow_drop_down, color: Colors.green)
                            : Icon(Icons.arrow_drop_up, color: Colors.red)
                    ),
                    Text("${percent}%",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: percent < 0 ? Colors.green : Colors.red,
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: SfCartesianChart(
                // zoomPanBehavior: ZoomPanBehavior(
                //   enablePanning: true,
                // ),
                primaryXAxis: const CategoryAxis(
                  majorGridLines: MajorGridLines(width: 0),
                  // initialZoomFactor: 0.1,
                ),
                primaryYAxis: NumericAxis(
                  // opposedPosition: true,
                  axisLine: const AxisLine(width: 0),
                  numberFormat: NumberFormat.compact(locale: 'vi'),
                  majorTickLines: const MajorTickLines(size: 0),
                  majorGridLines: const MajorGridLines(width: 0),
                  minimum: 0,
                ),
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  // Legend will be placed at the bottom
                  overflowMode: LegendItemOverflowMode.wrap,
                  // To place legend items in multiple rows
                  alignment: ChartAlignment.center,
                  // To align the legend at center
                  itemPadding: 10,
                  // Padding between each legend item
                  toggleSeriesVisibility: true,
                  // To show/hide series on legend click
                  // Spacing between columns
                  textStyle: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                series: <CartesianSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                      legendItemText: "Khoản thu",
                      dataSource:  chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.income,
                      color: Colors.green,
                      // Width of the columns
                      width: 0.8,
                      // Spacing between the columns
                      spacing: 0.2,
                      animationDuration: 0,
                  ),
                  ColumnSeries<ChartData, String>(
                    legendItemText: "Khoản chi",
                    dataSource:  chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.expense,
                    color: Colors.red,
                    // Width of the columns
                    width: 0.8,
                    // Spacing between the columns
                    spacing: 0.2,
                    animationDuration: 0,
                  ),
                  // SplineSeries<ChartData, String>(
                  //   dataSource:  chartData,
                  //   splineType: SplineType.cardinal,
                  //   xValueMapper: (ChartData data, _) => data.x,
                  //   yValueMapper: (ChartData data, _) => ((data.income - data.expense) / data.income * 100)  * data.income,
                  //
                  //   color: Colors.blueAccent,
                  //   width: 0.8,
                  //   // Spacing between the columns
                  //   animationDuration: 0,
                  //   // Width of the columns
                  // ),
                ]
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nhóm chi nhiều nhất trong ${chartType == 0 ? "tuần" : "tháng" }",
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if(mostGroupExpense.isNotEmpty)
                  for(final item in mostGroupExpense.entries)
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 20.0,
                        child: Image.asset(item.key.icon ?? Constants.IMAGE_DEFAULT),
                      ),
                      title: Text(item.key.name ?? "",
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(Utils.currencyFormat(item.value),
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                if(!mostGroupExpense.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: Text("Nhóm chi tiêu nhiều nhất sẽ được hiển thị ở đây!",
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.expense, this.income);
  final String x;
  final double expense;
  final double income;
}

