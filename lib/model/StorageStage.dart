
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:onemorecoin/Objects/ShowType.dart';
import 'package:onemorecoin/model/BudgetModel.dart';
import 'package:onemorecoin/model/WalletModel.dart';
import 'package:onemorecoin/pages/Transaction.dart';
import 'package:realm/realm.dart';

import '../Objects/TabTransaction.dart';
import '../utils/MyDateUtils.dart';
import '../utils/Utils.dart';
import 'GroupModel.dart';
import 'TransactionModel.dart';

part 'StorageStage.g.dart';

@RealmModel()
class _StorageStage {

  @PrimaryKey()
  late int id;

  late String key;

  late String? value;

}

class StorageStageProxy extends ChangeNotifier{

  late Realm realm;

  late bool _isLogin = false;
  StorageStageProxy(){
    var config = Configuration.local([StorageStage.schema]);
    realm = Realm(config);
    var all = realm.all<StorageStage>();

    if(all.isEmpty){
      realm.write(() {
        realm.addAll([
          StorageStage(1, "isLogin", value: "false"),
        ]);
      });
    }else{
      _isLogin = all[0].value == "true";
    }
  }

  bool get isLogin => _isLogin;

  set isLogin(bool value) {
    realm.write(() {
      realm.find<StorageStage>(1)!.value = value.toString();
    });
    _isLogin = value;
    // notifyListeners();
  }

  saveInfoUser(String key, String value){
    realm.write(() {
      realm.add(StorageStage(2, key, value: value), update: true);
    });
  }

  String? getInfoUser(String key){
    var all = realm.all<StorageStage>();
    var result = all.where((element) => element.key == key);
    if(result.isNotEmpty){
      return result.first.value;
    }
    return null;
  }


}
