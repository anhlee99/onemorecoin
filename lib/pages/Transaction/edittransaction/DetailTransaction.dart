import 'package:flutter/material.dart';
import 'package:onemorecoin/commons/Constants.dart';
import 'package:onemorecoin/model/GroupModel.dart';
import 'package:onemorecoin/model/StorageStage.dart';
import 'package:onemorecoin/model/TransactionModel.dart';
import 'package:onemorecoin/model/WalletModel.dart';
import 'package:onemorecoin/utils/MyDateUtils.dart';
import 'package:onemorecoin/utils/Utils.dart';
import 'package:onemorecoin/widgets/AlertDiaLog.dart';
import 'package:onemorecoin/widgets/ShowTransaction.dart';
import 'package:provider/provider.dart';

import '../../../Objects/AlertDiaLogItem.dart';


class DetailTransaction extends StatefulWidget {
  final TransactionModel transactionModel;

  const DetailTransaction({super.key,
    required this.transactionModel
  });

  @override
  State<DetailTransaction> createState() => _DetailTransactionState();
}

class _DetailTransactionState extends State<DetailTransaction> {

  late TransactionModel transactionModel;
  late GroupModel? groupModel;
  late WalletModel? walletModel;

  @override
  void initState() {
    super.initState();
  }

  void _removeTransaction(BuildContext context, TransactionModel transactionModel) {
    var transactionsProxy = context.read<TransactionModelProxy>();
    TransactionModel transactions = transactionsProxy.getById(transactionModel.id);
    var wallet = context.read<WalletModelProxy>().getById(transactions.walletId);
    double balance = wallet.balance! - (transactions.type == 'income' ? transactions.amount! : -transactions.amount!);
    context.read<WalletModelProxy>().updateBalance(wallet, balance);
    context.read<TransactionModelProxy>().delete(transactions);
  }

  @override
  Widget build(BuildContext context) {
    transactionModel = context.read<TransactionModelProxy>().getById(widget.transactionModel.id);
    groupModel = transactionModel.group;
    walletModel = transactionModel.wallet;
    return Scaffold(
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
                  Text("Sổ giao dịch",
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
                ShowTransactionPage(context,
                    transactionModel: transactionModel,
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
      body: Container(
        padding: EdgeInsets.only(top: 20.0),
        color: Colors.grey[100],
        child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
                        color: Colors.white,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50.0,
                              child: Image.asset(groupModel!.icon ?? Constants.IMAGE_DEFAULT),
                            ),
                            Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(groupModel?.name ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        if(transactionModel.note != null && transactionModel.note!.isNotEmpty)
                                          Text(transactionModel.note ?? "",
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    )
                                )
                            )
                          ],
                        )
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        color: Colors.white,
                        child: Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 50.0,
                              ),
                              Flexible(
                                  child: FittedBox(
                                    child: Text(Utils.currencyFormat(transactionModel.amount!),
                                      style: TextStyle(
                                        color: transactionModel.type == 'income' ? Colors.green : Colors.red,
                                        fontSize: 25,
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                        )
                    ),
                    Container(
                        padding: EdgeInsets.all(10.0),
                        color: Colors.white,
                        child: Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 50.0,
                              ),
                              Expanded(
                                  child: Divider(
                                    height: 1.0,
                                    color: Colors.grey[300],
                                  )
                              )
                            ],
                          ),
                        )
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                        color: Colors.white,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50.0,
                              child: Icon(Icons.calendar_today),
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(MyDateUtils.toStringFormat00FromString(transactionModel.date!),
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                )
                            )
                          ],
                        )
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                        color: Colors.white,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50.0,
                              child: CircleAvatar(
                                radius: 15.0,
                                backgroundColor: Colors.transparent,
                                child: Image.asset(walletModel!.icon ?? Constants.IMAGE_DEFAULT),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(walletModel?.name ?? "",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                )
                            )
                          ],
                        )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Material(
                  child: InkWell(
                    onTap: () {
                      showAlertDialog(
                        context: context,
                        title: Text("Xác nhận xoá giao dịch này?"),
                        optionItems: [
                          AlertDiaLogItem(
                            text: "Xoá",
                            textStyle: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.normal
                            ),
                            okOnPressed: () {
                              _removeTransaction(context, transactionModel);
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
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: const Center(
                            child: Text("Xoá",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.red,
                              ),
                            )
                        )
                    ),
                  ),
                ),
              )
            ]
        ),
      ),
    );
  }
}

