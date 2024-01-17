import 'package:flutter/cupertino.dart';
import 'package:realm/realm.dart';

part 'GroupModel.g.dart';


@RealmModel()
class _GroupModel {

  @PrimaryKey()
  late int id;

  late String? name;

  late String? type;

  late String? icon;

  late int index;

}

// A proxy of the GroupModel class
class GroupModelProxy extends ChangeNotifier {

  late Realm realm;

  GroupModelProxy(){
    var config = Configuration.local([GroupModel.schema]);
    realm = Realm(config);
    var allGroups = realm.all<GroupModel>();
    if(allGroups.isEmpty) {
      realm.write(() {
        realm.addAll([
          GroupModel(1, 1, name: "Ăn uống",type: "expense",icon: "assets/images/icon_wallet_primary.png",),
          GroupModel(2, 1,name: "Di chuyển",type: "expense",icon: "assets/images/icon_wallet_primary.png",),
          GroupModel(3,1,name: "Mua sắm",type: "expense",icon: "assets/images/icon_wallet_primary.png",),
          GroupModel(4, 1,name: "Sức khỏe",type: "expense",icon: "assets/images/icon_wallet_primary.png",),
          GroupModel(5,1,name: "Giải trí",type: "expense", icon: "assets/images/icon_wallet_primary.png"),
          GroupModel(6,1,name: "Tiền nhà",type: "expense", icon: "assets/images/icon_wallet_primary.png"),
          GroupModel(7,1,name: "Tiền nước",type: "expense", icon: "assets/images/icon_wallet_primary.png"),
          GroupModel(8,1,name: "Tiền internet",type: "expense", icon: "assets/images/icon_wallet_primary.png"),
          GroupModel(9,1,name: "Tiền điện thoại",type: "expense", icon: "assets/images/icon_wallet_primary.png"),
          GroupModel(10,1,name: "Tiền học",type: "expense", icon: "assets/images/icon_wallet_primary.png"),
          GroupModel(11,1,name: "Tiền khác",type: "expense", icon: "assets/images/icon_wallet_primary.png"),
          GroupModel(12,1,name: "Lương",type: "income",icon: "assets/images/icon_wallet_primary.png",),
          GroupModel(13,1,name: "Thưởng",type: "income",icon: "assets/images/icon_wallet_primary.png",),
          GroupModel(14,1,name: "Lãi",type: "income",icon: "assets/images/icon_wallet_primary.png",),
          GroupModel(15,1,name: "Bán đồ",type: "income",icon: "assets/images/icon_wallet_primary.png",),
          GroupModel(16,1,name: "Khác",type: "income",icon: "assets/images/icon_wallet_primary.png",),
        ]);
      });
    }
  }

  GroupModel getById(int id){
    return realm.find<GroupModel>(id)!;
  }

  GroupModel getByPosition(int position){
    return realm.all<GroupModel>()[position];
  }

  List<GroupModel> getAll(){
    List<GroupModel> list = realm.all<GroupModel>().toList();
    list.sort((a, b) => b.index.compareTo(a.index));
    return list;
  }

  void add(GroupModel group){
    realm.write(() {
      realm.add(group);
    });
    notifyListeners();
  }

  void update(GroupModel group){
    realm.write(() {
      realm.add(group, update: true);
    });
    notifyListeners();
  }

  void delete(GroupModel group){
    realm.write(() {
      realm.delete(group);
    });
    notifyListeners();
  }

  void deleteAll(){
    realm.write(() {
      var allGroups = realm.all<GroupModel>();
      for (final item in allGroups) {
        realm.delete(item);
      }
    });
    notifyListeners();
  }


  void close(){
    realm.close();
  }

  int getId(){
    List<GroupModel> list = realm.all<GroupModel>().toList();
    return list.length + 1;
  }

}