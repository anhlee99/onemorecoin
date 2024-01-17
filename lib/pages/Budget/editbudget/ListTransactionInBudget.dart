import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onemorecoin/model/BudgetModel.dart';
import 'package:onemorecoin/widgets/TransactionItem.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../../commons/Constants.dart';
import '../../../model/GroupModel.dart';
import '../../../model/TransactionModel.dart';
import '../../../model/WalletModel.dart';
import '../../../utils/MyDateUtils.dart';
import '../../../utils/Utils.dart';



class ListTransactionInBudget extends StatefulWidget {
  final BudgetModel? budgetModel;
  const ListTransactionInBudget({super.key, this.budgetModel});

  @override
  State<ListTransactionInBudget> createState() => _ListTransactionInBudgetState();
}

class _ListTransactionInBudgetState extends State<ListTransactionInBudget> {
  late BudgetModel budgetModel;
  late WalletModel? walletModel;
  late GroupModel? groupModel;
  late List<TransactionModel> transactions = [];
  late double totalAmountTransaction = 0;
  String _transactionViewModel = 'date';

  List<Widget> _renderTransactionAccordingDate(List<TransactionModel> transactions) {

    List<Widget> result = [];
    Map<String, List<TransactionModel>> map = {};
    for (final item in transactions) {
      DateTime day = MyDateUtils.dateOnly(DateTime.parse(item.date ?? ""));
      if (map.containsKey(day.toString())) {
        map[day.toString()]!.add(item);
      } else {
        map[day.toString()] = [item];
      }
    }
    for(final key in map.keys){
      result.add(
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: StickyHeader(
              header: _renderStickyHeaderTransaction(key, map[key]!),
              content: Column(
                children: [
                  for (final item in map[key]!)
                    TransactionItem(transaction: item)
                ],
              ),
            ),
          )
      );
    }
    return result;
  }


  _renderStickyHeaderTransaction(String date, List<TransactionModel> transactions ) {
    double totalAmount = Utils.sumAmountTransaction(transactions);

    if(_transactionViewModel == 'group'){
      GroupModel? groupModel = transactions[0].group;
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            Center(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ListTile(
                    leading: Image.asset(groupModel?.icon ?? Constants.IMAGE_DEFAULT),
                    title: Text(groupModel?.name ?? ""),
                    subtitle: Text("${transactions.length} giao dịch", style: TextStyle(color: Colors.grey[500] )),
                    trailing: Text((totalAmount > 0 ? "+" : "") + Utils.currencyFormat(totalAmount),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0
                        )
                    ),
                  ),
                )
            ),
            Divider(
                height: 1,
                color: Colors.grey[300]
            )
          ],
        ),

      );
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Center(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListTile(
                  leading: FittedBox(
                    fit: BoxFit.fill,
                    child: Container(
                        child: Text(MyDateUtils.getDateInMonthFromString(date).toString(),
                          style: const TextStyle(fontSize: 50.0),
                        )),
                  ),
                  title: Text(MyDateUtils.getNameDayOfWeekFromString(date),
                  ),
                  subtitle: Text(MyDateUtils.getMonthAndYearFromString(date),
                  ),
                  trailing: Text((totalAmount > 0 ? "+" : "") + Utils.currencyFormat(totalAmount),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                      )
                  ),
                ),

              )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    budgetModel = widget.budgetModel!;
    groupModel = budgetModel.group;
    walletModel = budgetModel.wallet;
    transactions = budgetModel.transactions;
    totalAmountTransaction = -1 * Utils.sumAmountTransaction(transactions);
    totalAmountTransaction == 0 ? totalAmountTransaction = 0 : totalAmountTransaction;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leadingWidth: 100.0,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 10.0),
              child: const Row(
                children: [
                  Icon(Icons.arrow_back_ios),
                  Text("Chi tiết",
                      style: TextStyle(
                        fontSize: 16.0,
                      )
                  ),
                ],
              ),
            )
        ),
        title: Text(groupModel!.name ?? "", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${transactions.length} kết quả",
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Khoản chi",
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey,
                          )
                      ),
                      Text(Utils.currencyFormat(totalAmountTransaction),
                        style: TextStyle(
                          color: totalAmountTransaction > 0 ? Colors.red : Colors.green,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          ),
          ..._renderTransactionAccordingDate(transactions),
        ],
      ),
    );
  }
}
