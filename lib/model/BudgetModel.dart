

import 'package:flutter/cupertino.dart';

import 'GroupModel.dart';
import 'TransactionModel.dart';
import 'WalletModel.dart';
import 'package:realm/realm.dart';

part 'BudgetModel.g.dart';

@RealmModel()
class _BudgetModel {

  @PrimaryKey()
  late int id;

  late String? title;

  late double? budget;

  late String? unit = "VND";

  late String? type = "expense";

  late String? fromDate;

  late String? toDate;

  late String? note;

  late bool? isRepeat = false;

  late int walletId;

  late int groupId;

  late String? budgetType = "month";  // week, month, quarter, year

  @Ignored()
  late WalletModel? wallet = WalletModelProxy().getById(walletId);

  @Ignored()
  late GroupModel? group = GroupModelProxy().getById(groupId);

  @Ignored()
  late List<TransactionModel> transactions = TransactionModelProxy().getAllForBudget(groupId, walletId, fromDate, toDate);

}

// A proxy of the BudgetModel class

class BudgetModelProxy extends ChangeNotifier{

  late Realm realm;

  BudgetModelProxy() {
    var config = Configuration.local([BudgetModel.schema]);
    realm = Realm(config);
    // var allBudgets = realm.all<BudgetModel>();
  }

  BudgetModel getById(int id) {
    return realm.find<BudgetModel>(id)!;
  }

  void deleteById(int id) {
    realm.delete(realm.find<BudgetModel>(id)!);
  }

  BudgetModel getByPosition(int position) {
    return realm.all<BudgetModel>()[position];
  }

  List<BudgetModel> getAll() {
    List<BudgetModel> list = realm.all<BudgetModel>().toList();
    list.sort((a, b) => DateTime.parse(b.fromDate ?? "").compareTo(DateTime.parse(a.fromDate ?? "")));
    return list;
  }

  List<BudgetModel> getAllByWalletId(int walletId) {
    List<BudgetModel> list = [];
    if (walletId == 0) {
      list = realm.all<BudgetModel>().toList();
    } else {
      list = realm.query<BudgetModel>("walletId == $walletId").toList();
    }
    list.sort((a, b) => b.id.compareTo(a.id));
    return list;
  }

  int getId() {
    var allBudgets = realm.all<BudgetModel>();
    if (allBudgets.isEmpty) {
      return 1;
    } else {
      return allBudgets.last.id + 1;
    }
  }

  void add(BudgetModel budget) {
    realm.write(() {
      realm.add(budget);
    });
    notifyListeners();
  }

  void update(BudgetModel budget) {
    realm.write(() {
      realm.add(budget, update: true);
    });
    notifyListeners();
  }

  void delete(BudgetModel budget) {
    realm.write(() {
      realm.delete(budget);
    });
    notifyListeners();
  }

  void deleteAll() {
    realm.write(() {
      var allBudgets = realm.all<BudgetModel>();
      for (final item in allBudgets) {
        realm.delete(item);
      }
    });
    notifyListeners();
  }


  void close() {
    realm.close();
  }

}

