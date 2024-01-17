import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onemorecoin/model/TransactionModel.dart';

import '../commons/Constants.dart';
import '../utils/MyDateUtils.dart';
import '../utils/Utils.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final String? showType;
  const TransactionItem({super.key,
    required this.transaction,
    this.showType = 'date'
  });


  @override
  Widget build(BuildContext context) {
    if(showType == 'date'){
      return Material(
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/DetailTransaction', arguments: transaction);
            },
            leading: Container(
              width: 40,
              height: 40,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image.asset(transaction.group?.icon ?? Constants.IMAGE_DEFAULT),
              ),
            ),
            title: Text(transaction.group?.name ?? ""),
            subtitle: (transaction.note != null && transaction.note!.isNotEmpty) ?Text(transaction.note!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[500]),
            ) : null,
            trailing: Text(Utils.currencyFormat(transaction.amount!),
                style: TextStyle(
                    color: transaction.type == "income" ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0
                )
            ),
          )
      );
    }
    return Material(
      child: Container(
        color: Colors.white,
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/DetailTransaction', arguments: transaction);
          },
          leading: Container(
            width: 40,
            height: 40,
          ),
          title: Text("${MyDateUtils.toStringFormat01FromString(transaction.date!)}, ${MyDateUtils.getNameDayOfWeekFromString(transaction.date!)}",
            style: const TextStyle(
              fontSize: 13.0,
            ),
          ),
          subtitle: (transaction.note != null && transaction.note!.isNotEmpty) ?
          Text(transaction.note ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[500])
          ) : null,
          trailing: Text(Utils.currencyFormat(transaction.amount!),
              style: TextStyle(
                  color: transaction.type == "income" ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0
              )

          ),
        ),
      ),
    );
  }
}
