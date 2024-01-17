
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:onemorecoin/model/GroupModel.dart';
import 'package:onemorecoin/model/TransactionModel.dart';
import 'package:provider/provider.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../commons/Constants.dart';

class ReportForPeriod extends StatefulWidget {

  const ReportForPeriod({super.key, this.title, this.type, this.fromDate, this.toDate});

  final String? title;
  final String? type;
  final DateTime? fromDate;
  final DateTime? toDate;

  @override
  State<ReportForPeriod> createState() => _ReportForPeriodState();
}


class _ReportForPeriodState extends State<ReportForPeriod> {

  late DateTime _fromDate;
  late DateTime _toDate;
  int chartType = 0;

  @override
  void initState() {
    super.initState();
    _fromDate = widget.fromDate ?? DateTime.parse("2021-01-01");
    _toDate = widget.toDate ?? DateTime.parse("2023-12-31");
  }

  @override
  Widget build(BuildContext context) {
    List<GroupModel> groupModels =  context.read<GroupModelProxy>().getAll();
    // List<TransactionModel> transactions =  context.read<TransactionModelProxy>().getAll();
    List<TransactionModel> transactions = [];
    Map<int, List<TransactionModel>> mapByGroup = {};
    for (final item in transactions) {
      if (mapByGroup.containsKey(item.groupId)) {
        mapByGroup[item.groupId]!.add(item);
      } else {
        mapByGroup[item.groupId] = [item];
      }
    }
    List<ChartData> data = [];
    for (final key in mapByGroup.keys) {
      double totalAmount = 0;
      for (final item in mapByGroup[key]!) {
        totalAmount += item.amount ?? 0;
      }
      data.add(ChartData(groupModels[key].name ?? "", totalAmount, groupModels[key]));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('ReportForPeriod'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              SlideSwitcher(
                children: [
                  Icon(Icons.pie_chart_outline,
                    color: chartType == 0 ? Colors.black : Colors.grey,
                  ),
                  Icon(Icons.bar_chart_outlined,
                    color: chartType == 1 ? Colors.black : Colors.grey,
                  ),
                ],
                onSelect: (int index) => setState(() => chartType = index),
                containerColor: Colors.grey[200]!,
                slidersColors: [Colors.white],
                containerBorderRadius: 5,
                indents: 3,
                containerHeight: 30,
                containerWight: 315,
              ),
              Container(
                  child: Container(
                    color: Colors.red,
                    child: SfCircularChart(
                      // legend: Legend(
                      //   shouldAlwaysShowScrollbar: true,
                      //   isVisible: true,
                      //   position: LegendPosition.bottom,
                      // ),
                      series: <CircularSeries>[
                        DoughnutSeries<ChartData, String>(
                            dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                showCumulativeValues: true,
                                labelPosition: ChartDataLabelPosition.inside,
                                labelIntersectAction: LabelIntersectAction.shift,
                                builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                                  return Container(
                                    width: 30,
                                    height: 60,
                                    child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 10,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(data.groupModel.icon ?? Constants.IMAGE_DEFAULT),
                                            Text("123", style:
                                            TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                            ))
                                          ],
                                        )
                                    ),
                                  );
                                }
                            ),
                            dataSource: data,
                            xValueMapper: (ChartData sales, _) => sales.x,
                            yValueMapper: (ChartData sales, _) => sales.y,
                            dataLabelMapper: (ChartData data, _) => data.x,
                            animationDuration: 1000
                        ),
                      ],
                    ),
                  )
              ),
            ],
          )
        ],
      )
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.groupModel);
  final String x;
  final double y;
  final GroupModel groupModel;
}