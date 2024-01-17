import 'package:realm/realm.dart';
import 'dart:io';

part 'catalog.g.dart';

@RealmModel()
class _Item {
  @PrimaryKey()
  late int id;

  late String name;

  int price = 42;
}

var config = Configuration.local([Item.schema]);

var realm = Realm(config);

var myItem = Item(0, 'Pen', price: 4);
