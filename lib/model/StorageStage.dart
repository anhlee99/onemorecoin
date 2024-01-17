
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:onemorecoin/Objects/ShowType.dart';
import 'package:onemorecoin/model/BudgetModel.dart';
import 'package:onemorecoin/model/WalletModel.dart';
import 'package:onemorecoin/pages/Transaction.dart';

import '../Objects/TabTransaction.dart';
import '../utils/MyDateUtils.dart';
import '../utils/Utils.dart';
import 'GroupModel.dart';
import 'TransactionModel.dart';

class StorageStage extends ChangeNotifier{

  final List<TabTransaction> _listTab = [];

  late ShowType _showType = ShowType.date;

  late WalletModel _walletModel = WalletModel(0, name: "Tất cả các ví", icon: null, currency: "VND");

  late TransactionModelProxy _transactionModelProxy;

  late BudgetModelProxy _budgetModelProxy;

  late List<TransactionModel> _transactionModels = _transactionModelProxy.transactionModels;

  StorageStage(TransactionModelProxy transactionModelProxy, BudgetModelProxy budgetModelProxy){
    _transactionModelProxy = TransactionModelProxy();
    _budgetModelProxy = BudgetModelProxy();
    init();
  }

  init(){
    _transactionModels = TransactionModelProxy().getAll();
    _showType = ShowType.date;
    generateListTabTransaction(Utils.getListTabShowTypeTransaction(_showType, 20));
  }

  ShowType get showType => _showType;

  set showType(ShowType value) {
    _showType = value;
  }

  TransactionModelProxy get transactionModelProxy => _transactionModelProxy;

  set transactionModelProxy(TransactionModelProxy value) {
    _transactionModelProxy = value;
    notifyListeners();
  }

  BudgetModelProxy get budgetModelProxy => _budgetModelProxy;

  set budgetModelProxy(BudgetModelProxy value) {
    _budgetModelProxy = value;
    notifyListeners();
  }

  List<TransactionModel> get transactionModels => _transactionModelProxy.getAll();

  List<TabTransaction> get listTab => _listTab;

  void generateListTabTransaction(List<TabTransaction> listTabNoTransaction){
    _listTab.clear();
    _listTab.addAll(listTabNoTransaction);
    var transactions = _transactionModelProxy.getAll();
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
    // notifyListeners();
  }

  List<TabTransaction> generateListTabTransactionInTransactionPage(ShowType showType, WalletModel walletModel){
    if(showType == _showType && walletModel.id == _walletModel.id){
      return _listTab;
    }
    _showType = showType;
    _walletModel = walletModel;
    List<TabTransaction> listTabNoTransaction = Utils.getListTabShowTypeTransaction(showType, 20);
    _listTab.clear();
    _listTab.addAll(listTabNoTransaction);
    var transactions = getTransactionByWalletId(walletModel.id);
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
    return _listTab;
    // notifyListeners();
  }

  List<TransactionModel> getTransactionByWalletId(int walletId){
    return _transactionModels.where((element) => (element.walletId == walletId || walletId == 0)).toList();
  }

  List<TransactionModel> getNewest(int limit){
    return _transactionModels.sublist(max(_transactionModels.length, limit) - limit, _transactionModels.length);
  }

  void addTransaction(TransactionModel transactionModel){
    _transactionModelProxy.add(transactionModel);
    _transactionModels.add(transactionModel);
    // notifyListeners();
  }

  void updateTransaction(TransactionModel transactionModel){
    _transactionModelProxy.update(transactionModel);
    notifyListeners();
  }

  void deleteTransaction(TransactionModel transactionModel){
    _transactionModelProxy.delete(transactionModel);
    notifyListeners();
  }
}