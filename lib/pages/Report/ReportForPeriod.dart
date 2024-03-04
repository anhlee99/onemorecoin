
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onemorecoin/model/GroupModel.dart';
import 'package:onemorecoin/model/TransactionModel.dart';
import 'package:provider/provider.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Objects/TabTransaction.dart';
import '../../commons/Constants.dart';
import '../../utils/Utils.dart';

class ReportForPeriod extends StatefulWidget {

  const ReportForPeriod({super.key
    , this.tabIndex
  });

  final int? tabIndex;

  @override
  State<ReportForPeriod> createState() => _ReportForPeriodState();
}


class _ReportForPeriodState extends State<ReportForPeriod> with TickerProviderStateMixin {

  int chartType = 0;

  final List<Tab> _tabs = <Tab>[];
  List<TabTransaction> listTab = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

  }

  List<Tab> getTabs() {
    _tabs.clear();
    for (int i = 0; i < listTab.length; i++) {
      _tabs.add(
        Tab(
          child: Text(listTab[i].name),
        ),
      );
    }
    return _tabs;
  }

  List<Widget> _generateListTabTransaction(BuildContext context, List<TransactionModel> transactions, List<TabTransaction> listTab){
      List<Widget> list = [];
      double amountBefore = 0;
      for (int i = 0; i < listTab.length; i++) {
        double amountInPeriod = Utils.sumAmountTransaction(listTab[i].transactions);
        List<ChartData> data = _calculate(context, listTab[i].transactions);
        if (data.isNotEmpty) {
          list.add(
              ListView(
                controller: ModalScrollController.of(context),
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 1.0),
                    padding: const EdgeInsets.only(top: 10.0),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                child: Text("Số dư đầu kỳ"),
                              ),
                              Flexible(
                                child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text("${Utils.currencyFormat(amountBefore)}", maxLines: 1)
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                child: Text("Chi tiêu trong kỳ"),
                              ),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text("${Utils.currencyFormat(amountInPeriod)}", maxLines: 1),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                child: Text("Số dư cuối kỳ"),
                              ),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text("${(amountBefore + amountInPeriod > 0 ? "+" : "")}${Utils.currencyFormat(amountBefore + amountInPeriod)}", maxLines: 1),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: [
                          if(chartType == 0)
                            Center(
                              child: SfCircularChart(
                                margin: const EdgeInsets.all(0),
                                series: <CircularSeries>[
                                  DoughnutSeries<ChartData, String>(
                                      dataLabelSettings: DataLabelSettings(
                                          isVisible: true,
                                          showCumulativeValues: true,
                                          labelPosition: ChartDataLabelPosition.inside,
                                          useSeriesColor: true,
                                          builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                                            return Text(data.percent.toStringAsFixed(2) + "%");
                                            // return Container(
                                            //   width: 30,
                                            //   height: 60,
                                            //   child: CircleAvatar(
                                            //       backgroundColor: Colors.transparent,
                                            //       radius: 10,
                                            //       child: Column(
                                            //         mainAxisAlignment: MainAxisAlignment.center,
                                            //         children: [
                                            //           Image.asset(data.groupModel.icon ?? Constants.IMAGE_DEFAULT),
                                            //           Text(data.groupModel.name, style:
                                            //           TextStyle(
                                            //             color: Colors.black,
                                            //             fontSize: 10,
                                            //           ))
                                            //         ],
                                            //       )
                                            //   ),
                                            // );
                                          }
                                      ),
                                      dataSource: data,
                                      xValueMapper: (ChartData sales, _) => sales.x,
                                      yValueMapper: (ChartData sales, _) => sales.y,
                                      dataLabelMapper: (ChartData data, _) => data.x,
                                      animationDuration: 0
                                  ),
                                ],
                              ),
                            ),
                          for (final item in data)
                            ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 20,
                                  child: Image.asset(item.groupModel.icon ?? Constants.IMAGE_DEFAULT)
                              ),
                              title: Text(item.groupModel.name ?? ""),
                              subtitle: Text(item.percent.toStringAsFixed(2) + "%", style: TextStyle(color: Colors.grey[500] )),
                              trailing: Text(Utils.currencyFormat(item.y),
                                  style:  TextStyle(
                                      color: item.groupModel.type == 'expense' ? Colors.red : Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0
                                  )
                              ),
                            )
                        ],
                      )
                  )
                ],
              )
          );
        }else{
          list.add(
              LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return Center(
                  child: ListView(
                      controller: ScrollController(),
                      children: [
                        SizedBox(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            child: Align(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/empty-box.png",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  const Text("Không có giao dịch nào",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13.0
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ),
                      ]
                  ),
                );
              })
          );
        }
        amountBefore += amountInPeriod;
      }
      return list;
  }


  _calculate(BuildContext context, List<TransactionModel> transactions){
    List<ChartData> data = [];
    Map<int, List<TransactionModel>> mapByGroup = {};
    for (final item in transactions) {
      if (mapByGroup.containsKey(item.groupId)) {
        mapByGroup[item.groupId]!.add(item);
      } else {
        mapByGroup[item.groupId] = [item];
      }
    }

    for (final key in mapByGroup.keys) {
      double totalAmount = 0;
      for (final item in mapByGroup[key]!) {
        totalAmount += item.amount ?? 0;
      }
      GroupModel groupModel = context.read<GroupModelProxy>().getById(key);
      data.add(ChartData(groupModel.name ?? "", totalAmount, groupModel));
    }
    if (data.isEmpty) {
      return data;
    }
    double totalAmount = data.map((e) => e.y).reduce((value, element) => value + element);
    for (final item in data) {
      item.percent = item.y / totalAmount * 100;
    }
    data.sort((a, b) => b.y.compareTo(a.y));
    return data;
  }

  @override
  Widget build(BuildContext context) {
    listTab = context.read<TransactionModelProxy>().listTab;
    int? tabIndex = widget.tabIndex ?? (listTab.length > 2 ? listTab.length  - 2 : 0);
    _tabController = TabController(vsync: this, length: listTab.length, initialIndex: tabIndex);
    // _calculate(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('Báo cáo theo giai đoạn',
            style: TextStyle(fontWeight: FontWeight.bold)),
          leading: TextButton(
          child: const Text(
              'Hủy',
              style: TextStyle(
                fontSize: 16.0,
              )
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 1.0),
            height: 50,
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: getTabs()
            ),
          ),
          Expanded(
              child: TabBarView(
                controller: _tabController,
                  children: [
                    ..._generateListTabTransaction(context, [], listTab),
                    // SizedBox(height: 100),
                  ]
              )
          ),


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
  double percent = 0;

}