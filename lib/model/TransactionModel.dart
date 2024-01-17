import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:onemorecoin/model/GroupModel.dart';
import 'package:onemorecoin/model/WalletModel.dart';
import 'package:realm/realm.dart';

import '../Objects/ShowType.dart';
import '../Objects/TabTransaction.dart';
import '../utils/MyDateUtils.dart';
import '../utils/Utils.dart';

part 'TransactionModel.g.dart';

@RealmModel()
class _TransactionModel {

  @PrimaryKey()
  late String id;
  late String? title;
  late double? amount;
  late String? unit = "VND";
  late String? type = "income";
  late String? date;
  late String? note;
  late bool? addToReport = true;
  late String? notifyDate;
  late int walletId;

  @Ignored()
  late WalletModel? wallet = WalletModelProxy().getById(walletId);

  late int groupId;

  @Ignored()
  late GroupModel? group = GroupModelProxy().getById(groupId);
  // for reminder
}

// A proxy of the TransactionModel class
class TransactionModelProxy extends ChangeNotifier{

  late Realm realm;

  late List<TransactionModel> transactionModels = [];

  late List<TabTransaction> listTab = [];

  late ShowType showType = ShowType.date;

  late WalletModel _walletModel = WalletModel(0, name: "Tất cả các ví", icon: null, currency: "VND");

  TransactionModelProxy(){
    var config = Configuration.local([TransactionModel.schema]);
    realm = Realm(config);
    init();
    // var allTransactions = realm.all<TransactionModel>();
  }

  init(){
    transactionModels = getAll();
    showType = ShowType.date;
    generateListTabTransactionInTransactionPage(true, showType, walletModel);
  }

  WalletModel get walletModel => _walletModel;

  set walletModel(WalletModel value) {
    _walletModel = value;

    generateListTabTransactionInTransactionPage(true, showType, value);
  }

  TransactionModel getById(String id){
    return realm.find<TransactionModel>(id)!;
  }

  TransactionModel getByPosition(int position){
    return realm.all<TransactionModel>()[position];
  }

  List<TransactionModel> getAll(){
    List<TransactionModel> list = realm.all<TransactionModel>().toList();
    list.sort((a, b) => DateTime.parse(b.date ?? "").compareTo(DateTime.parse(a.date ?? "")));
    return list;
  }

  List<TransactionModel> getAllByDate(DateTime fromDate, DateTime toDate){
    List<TransactionModel> list = realm.all<TransactionModel>().toList();
    list = list.where((element) => DateTime.parse(element.date ?? "").isAfter(fromDate.subtract(const Duration(seconds: 1))) && DateTime.parse(element.date ?? "").isBefore(toDate.add(const Duration(seconds: 1)))).toList();
    return list;
  }

  List<TransactionModel> getNewest(int limit){
    return transactionModels.sublist(0, min(transactionModels.length, limit));
  }

  List<TransactionModel> getAllByWalletId(int walletId){
    List<TransactionModel> list = [];
    if(walletId == 0){
      list = realm.all<TransactionModel>().toList();
    }else {
      list = realm.query<TransactionModel>("walletId == $walletId").toList();
    }
    list.sort((a, b) => DateTime.parse(b.date ?? "").compareTo(DateTime.parse(a.date ?? "")));
    return list;
  }

  List<TransactionModel> getLimitByGroup(int groupId, int limit){
    List<TransactionModel> list = [];
    if(groupId == 0){
      list = realm.all<TransactionModel>().toList();
    }else {
      list = realm.query<TransactionModel>("groupId == $groupId").toList();
    }
    // list.sort((a, b) => DateTime.parse(b.date ?? "").compareTo(DateTime.parse(a.date ?? "")));
    return list.sublist(max(list.length, limit) - limit, list.length);
  }

  void add(TransactionModel transaction){
    realm.write(() {
      realm.add(transaction);
    });
    transactionModels.clear();
    transactionModels = getAll();
    listTab = generateListTabTransactionInTransactionPage(true, showType, walletModel);
    notifyListeners();
  }

  void update(TransactionModel transaction){
    realm.write(() {
      realm.add(transaction, update: true);
    });
    transactionModels.clear();
    transactionModels = getAll();
    listTab = generateListTabTransactionInTransactionPage(true, showType, walletModel);
    notifyListeners();
  }

  void delete(TransactionModel transaction){
    realm.write(() {
      realm.delete(transaction);
    });
    transactionModels.remove(transaction);
    listTab = generateListTabTransactionInTransactionPage(true, showType, walletModel);
    notifyListeners();
  }

  void deleteById(String id){
    realm.write(() {
      realm.delete(getById(id));
    });
    notifyListeners();
  }

  void deleteAll(){
    realm.write(() {
      var transactions = realm.all<TransactionModel>();
      for (final item in transactions) {
        realm.delete(item);
      }
    });
  }

  void close(){
    realm.close();
  }

  List<TransactionModel> getAllForBudget(int groupId, int walletId, String? fromDate, String? toDate) {
    List<TransactionModel> list = [];
    if (groupId == 0 && walletId == 0) {
      list = realm.all<TransactionModel>().toList();
    } else if (groupId == 0 && walletId != 0) {
      list = realm.query<TransactionModel>("walletId == $walletId").toList();
    } else if (groupId != 0 && walletId == 0) {
      list = realm.query<TransactionModel>("groupId == $groupId").toList();
    } else {
      list = realm.query<TransactionModel>("groupId == $groupId AND walletId == $walletId").toList();
    }
    if (fromDate != null && toDate != null) {
      list = list.where((element) => DateTime.parse(element.date ?? "").isAfter(DateTime.parse(fromDate).subtract(const Duration(seconds: 1))) && DateTime.parse(element.date ?? "").isBefore(DateTime.parse(toDate).add(const Duration(seconds: 1)))).toList();
    }
    list.sort((a, b) => DateTime.parse(b.date ?? "").compareTo(DateTime.parse(a.date ?? "")));
    return list;
  }

  List<TransactionModel> getTransactionByWalletId(int walletId){
    return transactionModels.where((element) => (element.walletId == walletId || walletId == 0)).toList();
  }

  List<TabTransaction> generateListTabTransactionInTransactionPage(bool require ,ShowType showTypeRequest, WalletModel walletModelRequest){
    if(showType == showTypeRequest && _walletModel.id == walletModelRequest.id && !require){
      return listTab;
    }
    showType = showTypeRequest;
    _walletModel = walletModelRequest;
    List<TabTransaction> listTabNoTransaction = Utils.getListTabShowTypeTransaction(showTypeRequest, 20);
    listTab.clear();
    listTab.addAll(listTabNoTransaction);
    print("listTab.length: ${listTab.last.name}");
    var transactions = getTransactionByWalletId(_walletModel.id);
    transLoop:
    for(final tran in transactions){
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
    return listTab;
    // notifyListeners();
  }

}
