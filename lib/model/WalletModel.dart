

import 'package:flutter/cupertino.dart';
import 'package:realm/realm.dart';

part 'WalletModel.g.dart';

@RealmModel()
class _WalletModel {

  @PrimaryKey()
  late int id;

  late int index = 0;

  late String? name;
  late String? icon;

  late double? balance;
  late String? currency;

  late bool isDefault = false;
  late bool isReport = true;

}

// A proxy of the WalletModel class
class WalletModelProxy extends ChangeNotifier{

  late Realm realm;

  WalletModelProxy() {
    var config = Configuration.local([WalletModel.schema]);
    realm = Realm(config);
    var allWallets = realm.all<WalletModel>();
    if(allWallets.isEmpty){
      realm.write(() {
        realm.add(WalletModel(
          1,
          index: 0,
          name: "Ví chính",
          icon: "assets/images/icon_wallet_primary.png",
          balance: 0,
          currency: "VND",
          isDefault: true,
          isReport: true,
        ));
      });
    }
  }

  WalletModel getById(int id) {
    return realm.find<WalletModel>(id)!;
  }

  WalletModel getByPosition(int position) {
    return realm.all<WalletModel>()[position];
  }

  List<WalletModel> getAll() {
    List<WalletModel> list = realm.all<WalletModel>().toList();
    list.sort((a, b) => a.index.compareTo(b.index));
    return list;
  }

  void add(WalletModel wallet) {
    realm.write(() {
      realm.add(wallet);
    });
    notifyListeners();
  }

  void update(WalletModel wallet) {
    realm.write(() {
      realm.add(wallet, update: true);
    });
    notifyListeners();
  }

  void updateBalance(WalletModel wallet, double balance) {
    realm.write(() {
      wallet.balance = balance;
      realm.add(wallet, update: true);
    });
    notifyListeners();
  }

  void delete(WalletModel wallet) {
    realm.write(() {
      realm.delete(wallet);
    });
    notifyListeners();
  }

  void deleteAll() {
    realm.write(() {
      var allWallets = realm.all<WalletModel>();
      for (final item in allWallets) {
        realm.delete(item);
      }
    });

    realm.write(() {
      realm.add(WalletModel(
        1,
        index: 0,
        name: "Ví chính",
        icon: "assets/images/icon_wallet_primary.png",
        balance: 0,
        currency: "VND",
        isDefault: true,
        isReport: true,
      ));
    });

    // notifyListeners();
  }

  void close() {
    realm.close();
  }

  int getId() {
    var allWallets = realm.all<WalletModel>();
    if(allWallets.isEmpty){
      return 1;
    }else{
      return allWallets.last.id + 1;
    }
  }
}