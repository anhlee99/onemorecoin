import 'package:flutter/material.dart';
import 'package:onemorecoin/commons/Constants.dart';
import 'package:onemorecoin/model/BudgetModel.dart';
import 'package:onemorecoin/model/GroupModel.dart';
import 'package:onemorecoin/model/StorageStage.dart';
import 'package:onemorecoin/model/WalletModel.dart';
import 'package:onemorecoin/utils/MyDateUtils.dart';
import 'package:onemorecoin/utils/Utils.dart';
import 'package:onemorecoin/widgets/ShowListWallet.dart';
import 'package:provider/provider.dart';

import '../components/MyButton.dart';
import '../widgets/CustomLinearProgressIndicator.dart';
import '../widgets/ShowBudgetPage.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State createState() => _BudgetScreenState();
}


class _BudgetScreenState extends State<BudgetScreen> {

  String text = 'no data';
  WalletModel _wallet = WalletModel(0, name: "Tất cả các ví", icon: null, currency: "VND");

  Widget _generateInProcess(BuildContext context, List<BudgetModel> budgetModels){

    budgetModels = budgetModels.where((element) => !MyDateUtils.isAfterDateOnly(DateTime.now(), DateTime.parse(element.toDate!))).toList();

    if(budgetModels.isEmpty){
      return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/empty-box.png",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          const Text("Bạn chưa có ngân sách nào",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0
                            ),
                          ),
                           Container(
                             padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text("Bắt đầu tiết kiệm bằng cách tạo ngân sách và chúng tôi sẽ giúp bạn kiểm soát chi tiêu của mình",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13.0
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: 150,
                            child: MyButton(
                                backgroundColor: Colors.green,
                                onTap: () {
                                  showBudgetPage(context, budgetModel: null);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Center(
                                      child: Text("TẠO NGÂN SÁCH", style: TextStyle(fontSize: 15, color: Colors.white))
                                  ),
                                )
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ]
          ),
        );
      });
    }

    return ListView(
      children: [
        const SizedBox(height: 10),
        MyButton(
            onTap: () {
              showBudgetPage(context, budgetModel: null);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Center(
                  child: Text("TẠO NGÂN SÁCH", style: TextStyle(fontSize: 15, color: Colors.green))
              ),
            )
        ),
        ..._generateBudget(context, budgetModels),
        const SizedBox(height: 100.0)
      ]
    );
  }

  Widget _generateFinish(BuildContext context, List<BudgetModel> budgetModels){
    budgetModels = budgetModels.where((element) => MyDateUtils.isAfterDateOnly(DateTime.now(), DateTime.parse(element.toDate!))).toList();

    if(budgetModels.isEmpty){
      return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/empty-box.png",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          const Text("Chưa có ngân sách nào kết thúc",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
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
      });
    }

    Map<String, List<BudgetModel>> mapBudgetFromDate = {};
    for(var budget in budgetModels){
      if(mapBudgetFromDate[budget.fromDate] == null){
        mapBudgetFromDate[budget.fromDate!] = [];
      }
      mapBudgetFromDate[budget.fromDate]!.add(budget);
    }

    return ListView(
        children: [
          for(var key in mapBudgetFromDate.keys)
          ..._generateBudget(context, mapBudgetFromDate[key]!)
        ]
    );
  }

  List<Widget> _generateBudget(BuildContext context, List<BudgetModel> budgetModels){

    List<String> budgetType = ['week', 'month', 'quarter', 'year'];
    Map<String, List<BudgetModel>> mapBudget = {};
    for(var type in budgetType){
      mapBudget[type] = budgetModels.where((element) => element.budgetType == type).toList();
    }
    List<Widget> listWidget = [];
    for(var key in mapBudget.keys) {
      List<BudgetModel> budgets = mapBudget[key]!;
      if(budgets.isEmpty){
        continue;
      }
      double sumBudget = Utils.sumBudget(budgets);
      double sumAmount = Utils.sumBudgetAmountTransaction(budgets);
      listWidget.add(
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Ngày bắt đầu", ),
                      Text("Ngày kết thúc", ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(MyDateUtils.toStringFormat02FromString(budgets.first.fromDate)),
                      Text(MyDateUtils.toStringFormat02FromString(budgets.first.toDate)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(MyDateUtils.isAfterDateOnly(DateTime.now(), DateTime.parse(budgets.first.toDate!)) ? "" :  "${MyDateUtils.parseTypeToString(budgets.first.budgetType)} này", style: TextStyle( fontWeight: FontWeight.bold)),
                      Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text("${Utils.currencyFormat(sumBudget)}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle( fontWeight: FontWeight.bold)
                            ),
                          )
                      )
                    ],
                  ),
                  Text("${Utils.currencyFormat(sumAmount)}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 150
                    ),
                    child: Divider(
                      color: Colors.grey[300],
                      height: 1,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    )
                  ),
                  const SizedBox(height: 3),
                  Text("${Utils.currencyFormat(sumBudget + sumAmount)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: sumBudget + sumAmount > 0 ? Colors.green : Colors.red
                      )
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey[300],
              height: 1,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            for(var budget in budgets)
              _generateItemBudget(budget)
          ],
        )
      );
    }
    return listWidget;
  }

  Widget _generateItemBudget(BudgetModel budget){
    double sumAmount = -1 * Utils.sumAmountTransaction(budget.transactions);
    double restAmount = budget.budget! - sumAmount;
    GroupModel? group = budget.group;
    return MyButton(
        onTap: () {
          // showBudgetPage(context, budgetModel: budget);
          Navigator.pushNamed(context, '/DetailBudget', arguments: budget);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 50,
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(group?.icon ?? Constants.IMAGE_DEFAULT),
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(group?.name ?? "", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          if(budget.note != null && budget.note!.isNotEmpty)
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 200,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(budget.note!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 13, color: Colors.grey)
                                ),
                              ),
                            )
                        ],
                      ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        constraints: const BoxConstraints(
                          maxWidth: 150,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FittedBox(
                              child: Text(Utils.currencyFormat(budget.budget ?? 0),
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FittedBox(
                                  child: Text("${restAmount > 0 ? "Còn lại:" : "Bội chi:"}${Utils.currencyFormat(restAmount)}",
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: restAmount > 0 ? Colors.black : Colors.red,
                                      )
                                  )
                              ),
                            )
                          ],
                        ),
                      )
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(
                    width: 70,
                  ),
                  Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.white,
                        child: CustomLinearProgressIndicator(
                          backgroundColor: Colors.grey[300]!,
                          value: sumAmount,
                          maxProgressWidth: budget.budget!,
                        ),
                      )
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(
                    width: 70,
                  ),
                  Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                        height: 1,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                      )
                  )
                ],
              ),
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    var budgets = context.watch<BudgetModelProxy>().getAllByWalletId(_wallet.id);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Ngân sách', style: TextStyle(
            fontWeight: FontWeight.bold
        )),
        actions: [
          Material(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: (){
                  ShowListWalletPage(context, wallet: _wallet).then((value) {
                    if(value != null && value['wallet'] != null){
                      if(value['wallet'].id != _wallet.id){
                        setState(() {
                          _wallet = value['wallet'];
                        });
                      }
                    }
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _wallet.id == 0 ?  Icon(Icons.language_outlined, color: Colors.green,) : CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 15.0,
                        child: Image.asset(_wallet.icon ?? Constants.IMAGE_DEFAULT),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down_sharp, color: Colors.grey,),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: const TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: 'ĐANG ÁP DỤNG'),
                    Tab(text: 'ĐÃ KẾT THÚC'),
                  ],
                ),
              ),
              Expanded(
                  child: PageStorage(
                    bucket: PageStorageBucket(),
                    child: TabBarView(
                      children: [
                        PageStorage(
                          bucket: PageStorageBucket(),
                          child: _generateInProcess(context, budgets),
                        ),
                        PageStorage(
                          bucket: PageStorageBucket(),
                          child: _generateFinish(context, budgets),
                        ),
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget bodyWithReturnArgs(context) {
  return Container(
    alignment: Alignment.topCenter,
    child: Column(
      children: [
        IconButton(
            icon: Icon(Icons.close),
            onPressed: () =>
                Navigator.pop(context, 'Data returns from left side sheet')),
        Text('Body')
      ],
    ),
  );
}