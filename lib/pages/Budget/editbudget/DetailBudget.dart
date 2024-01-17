import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onemorecoin/components/MyButton.dart';
import 'package:onemorecoin/model/BudgetModel.dart';
import 'package:onemorecoin/utils/MyDateUtils.dart';
import 'package:onemorecoin/utils/Utils.dart';
import 'package:onemorecoin/widgets/ShowBudgetPage.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../../Objects/AlertDiaLogItem.dart';
import '../../../model/GroupModel.dart';
import '../../../model/TransactionModel.dart';
import '../../../model/WalletModel.dart';
import '../../../widgets/AlertDiaLog.dart';
import '../../../widgets/CustomLinearProgressIndicator.dart';

class DetailBudget extends StatefulWidget {

  final BudgetModel budgetModel;
  const DetailBudget({super.key,
    required this.budgetModel,
  });

  @override
  State<DetailBudget> createState() => _DetailBudgetState();
}

class _DetailBudgetState extends State<DetailBudget> {

  late BudgetModel budgetModel;
  late GroupModel? groupModel;
  late WalletModel? walletModel;
  late int numberDayOfBudget = 0;
  late double spentAmountToday = 0;
  late double expectedAmount = 0;
  late double suggestAmount = 0;
  late bool isFinish = false;
  late double totalAmountTransaction = 0;
  late double restAmount = 0;
  late int restNumberDayOfBudget = 0;
  late List<TransactionModel> transactions = [];


  @override
  void initState() {
    super.initState();
  }

  _deleteBudget(BuildContext context){
    showAlertDialog(
      context: context,
      title: Text("Xác nhận xoá ngân sách này?"),
      optionItems: [
        AlertDiaLogItem(
          text: "Xoá",
          textStyle: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.normal
          ),
          okOnPressed: () {
            context.read<BudgetModelProxy>().delete(budgetModel);
            Navigator.pop(context);
          },
        ),
      ],
      cancelItem: AlertDiaLogItem(
        text: "Huỷ",
        textStyle: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.normal
        ),
        okOnPressed: () {},
      ),
    );
  }

  _calculate(){
    budgetModel = context.read<BudgetModelProxy>().getById(widget.budgetModel.id);
    groupModel = budgetModel.group;
    walletModel = budgetModel.wallet;
    transactions = budgetModel.transactions;

    DateTime startDate = DateTime.parse(budgetModel.fromDate!);
    DateTime endDate = DateTime.parse(budgetModel.toDate!);
    numberDayOfBudget = endDate.difference(startDate).inDays + 1;
    restNumberDayOfBudget = DateTime.now().difference(endDate).inDays + 1 ;
    restNumberDayOfBudget = restNumberDayOfBudget * -1;
    totalAmountTransaction = -1 * Utils.sumAmountTransaction(transactions);
    totalAmountTransaction == 0 ? totalAmountTransaction = 0 : totalAmountTransaction;
    restAmount = budgetModel.budget! - totalAmountTransaction;
    expectedAmount = budgetModel.budget! / (numberDayOfBudget);

    if(restNumberDayOfBudget > 0){
      suggestAmount = restAmount / (restNumberDayOfBudget + 1);
      suggestAmount = suggestAmount > 0 ? suggestAmount : 0;
    }

    if(MyDateUtils.isAfterDateOnly(DateTime.now(), DateTime.parse(budgetModel.toDate!))) {
      isFinish = true;
    }
    List<TransactionModel> transactionsToday = transactions.where((element) => MyDateUtils.isSameDate(DateTime.now(), DateTime.parse(element.date!))).toList();
    spentAmountToday = Utils.sumAmountTransaction(transactionsToday) * -1;
    spentAmountToday == 0 ? spentAmountToday = 0 : spentAmountToday;
  }

  Widget _generateAreaChartTransaction(BuildContext context) {
    DateTime startDate = DateTime.parse(budgetModel.fromDate!);
    int days = numberDayOfBudget;
    List<ChartData> chartData = [];
    int lastDayUsed = 1;
    double sumAmountLastUsed = 0;
    for(int i = 0; i < days; i++){
      DateTime date = startDate.add(Duration(days: i));
      double sumAmount = Utils.sumAmountTransactionToDate(transactions, MyDateUtils.convertDateTimeFullDay(date)) * -1;
      if(sumAmount > 0 && sumAmountLastUsed == 0){
        sumAmountLastUsed = sumAmount;
        lastDayUsed = i + 1;
      }
      if(sumAmount > sumAmountLastUsed){
        lastDayUsed = i + 1;
        sumAmountLastUsed = sumAmount;
      }
      chartData.add(ChartData(date, sumAmount));
    }
    if(sumAmountLastUsed < budgetModel.budget!){
      chartData.removeRange(lastDayUsed, chartData.length);
    }
    List<ChartData> chartDataSuggest = [];
    if(lastDayUsed > 0 && lastDayUsed < days && sumAmountLastUsed < budgetModel.budget!){
      for(int i = 0; i < days; i++){
        DateTime date = startDate.add(Duration(days: i));
        double sumAmount = 0;
        if(i == lastDayUsed - 1){
          sumAmount = sumAmountLastUsed;
        }
        if(i >= lastDayUsed){
          sumAmount = restAmount / (days - lastDayUsed ) + sumAmountLastUsed;
          sumAmountLastUsed = sumAmount;
        }
        if(sumAmount > 0 || lastDayUsed == 1){
          chartDataSuggest.add(ChartData(date, sumAmount));
        }
      }
    }

    return Column(
      children: [

        SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              interval: days.toDouble() - 1,
              intervalType: DateTimeIntervalType.days,
              dateFormat: DateFormat('dd/MM/yyyy'),
              minimum: startDate,
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              maximumLabels: 2,
              axisLine: const AxisLine(
                color: Colors.blue,
                width: 1,
              ),
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              axisLine: const AxisLine(width: 0),
              numberFormat: NumberFormat.compact(locale: 'vi'),
              majorTickLines: const MajorTickLines(size: 0),
              minimum: 0,
              maximum: max(budgetModel.budget!, sumAmountLastUsed) * 1.2,
              plotBands: <PlotBand>[
                PlotBand(
                    shouldRenderAboveSeries: true,
                    start: budgetModel.budget,
                    end: budgetModel.budget,
                    borderColor: Colors.red,
                    color: Colors.green.withOpacity(0.1),
                    borderWidth: 1
                )
              ],
            ),
            series: <CartesianSeries>[

              AreaSeries<ChartData, DateTime>(
                dataSource: chartData,
                color: Colors.green.withOpacity(0.7),
                borderColor: Colors.green,
                // dashArray: const <double>[5, 5],
                borderWidth: 2,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                // animationDuration: 0,
              ),
              AreaSeries<ChartData, DateTime>(
                dataSource: chartDataSuggest,
                color: Colors.green.withOpacity(0.2),
                borderColor: Colors.green,
                dashArray: <double>[5, 5],
                borderWidth: 2,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                // animationDuration: 0,
              )
            ]
        ),
        Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.7),
                  radius: 5.0,
                ),
              ),
              const Text("Chi tiêu thực tế",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.2),
                  radius: 5.0,
                ),
              ),
              const Text("Dự kiến",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );

  }

  @override
  Widget build(BuildContext context) {
    _calculate();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leadingWidth: 150.0,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 10.0),
              child: const Row(
                children: [
                  Icon(Icons.arrow_back_ios),
                  Text("Ngân sách",
                      style: TextStyle(
                        fontSize: 16.0,
                      )
                  ),
                ],
              ),
            )
        ),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () {
                showBudgetPage(context,
                  budgetModel: budgetModel,
                );
              },
              child: const Text("Sửa",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              )
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20.0,),
            Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 70.0,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 25.0,
                            child: Image.asset(groupModel?.icon ?? ""),
                          ),
                        ),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(groupModel?.name ?? "",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if(budgetModel.note != null && budgetModel.note!.isNotEmpty)
                                  Text(budgetModel.note ?? "",
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.grey,
                                    ),
                                  )
                              ],
                            )
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 70.0,
                          ),
                          Expanded(
                              child: Container(
                                child: Text(Utils.currencyFormat(budgetModel.budget!),
                                  style: const TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 70.0,
                          ),
                          Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Đã chi",
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(Utils.currencyFormat(totalAmountTransaction),
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text( restAmount > 0 ? "Còn lại" : "Bội chi",
                                        style:  TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(Utils.currencyFormat(restAmount),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: restAmount > 0 ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 70.0,
                          ),
                          Expanded(
                              child: Container(
                                color: Colors.white,
                                child: CustomLinearProgressIndicator(
                                  backgroundColor: Colors.grey[300]!,
                                  value: totalAmountTransaction,
                                  maxProgressWidth: budgetModel.budget!,
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 70.0,
                            child: Icon(Icons.calendar_month_outlined, size: 28),
                          ),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${MyDateUtils.toStringFormat02FromString(budgetModel.fromDate!)} - ${MyDateUtils.toStringFormat02FromString(budgetModel.toDate!) }",
                                    style: const TextStyle(
                                    ),
                                  ),
                                  Text("Còn lại ${MyDateUtils.subtractTimeToDay(DateTime.now(), DateTime.parse(budgetModel.toDate!))} ",
                                    style: const TextStyle(
                                    ),
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 70.0,

                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 15.0,
                              child: Image.asset(walletModel?.icon ?? ""),
                            ),
                          ),
                          Expanded(
                            child:  Text(walletModel?.name ?? "",
                              style: const TextStyle(
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    if(budgetModel.isRepeat!)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 70.0,
                              child: Icon(Icons.repeat, size: 28),
                            ),
                            Expanded(
                              child:  Text("Ngân sách được tự động lặp lại ở kỳ tiếp theo",
                                style: TextStyle(
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0,),
            Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  color: Colors.white,
                  child: Column(
                    children: [
                      _generateAreaChartTransaction(context),
                      const SizedBox(height: 10.0,),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Chi trong hôm nay"),
                            Text(Utils.currencyFormat(spentAmountToday)),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tiêu chuẩn chi tiêu hằng ngày"),
                            Text(Utils.currencyFormat(expectedAmount)),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Thực tế chi tiêu hằng ngày"),
                            Text(Utils.currencyFormat(totalAmountTransaction / numberDayOfBudget)),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Dự kiến chi tiêu hằng ngày"),
                            Text(Utils.currencyFormat(suggestAmount)),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            ),
            const SizedBox(height: 20.0,),
            Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Container(
                color: Colors.white,
                height: 45.0,
                child: MyButton(
                    onTap: (){
                      Navigator.pushNamed(context, "/ListTransactionInBudget", arguments: budgetModel);
                    },
                    child: Center(
                        child: Text(
                            "Danh sách giao dịch",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16.0,
                            )
                        )
                    )
                ),
              ),
            ),
            const SizedBox(height: 20.0,),
            Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Container(
                color: Colors.white,
                height: 45.0,
                child: MyButton(
                  onTap: (){
                    _deleteBudget(context);
                  },
                  child: Center(
                    child: Text(
                        "Xoá",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                        )
                    )
                  )
                ),
              ),
            ),
            const SizedBox(height: 20.0,),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}