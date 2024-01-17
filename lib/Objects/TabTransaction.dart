
import 'package:onemorecoin/utils/Utils.dart';

import '../model/TransactionModel.dart';
import 'ShowType.dart';

class TabTransaction{

  late String name;
  late DateTime from;
  late DateTime to;
  bool isFuture = false;
  bool isAll = false;
  List<TransactionModel>  transactions = [];

  TabTransaction(this.name, this.from, this.to);
}