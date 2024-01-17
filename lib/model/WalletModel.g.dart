// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WalletModel.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class WalletModel extends _WalletModel
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  WalletModel(
    int id, {
    int index = 0,
    String? name,
    String? icon,
    double? balance,
    String? currency,
    bool isDefault = false,
    bool isReport = true,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<WalletModel>({
        'index': 0,
        'isDefault': false,
        'isReport': true,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'index', index);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'icon', icon);
    RealmObjectBase.set(this, 'balance', balance);
    RealmObjectBase.set(this, 'currency', currency);
    RealmObjectBase.set(this, 'isDefault', isDefault);
    RealmObjectBase.set(this, 'isReport', isReport);
  }

  WalletModel._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  int get index => RealmObjectBase.get<int>(this, 'index') as int;
  @override
  set index(int value) => RealmObjectBase.set(this, 'index', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get icon => RealmObjectBase.get<String>(this, 'icon') as String?;
  @override
  set icon(String? value) => RealmObjectBase.set(this, 'icon', value);

  @override
  double? get balance =>
      RealmObjectBase.get<double>(this, 'balance') as double?;
  @override
  set balance(double? value) => RealmObjectBase.set(this, 'balance', value);

  @override
  String? get currency =>
      RealmObjectBase.get<String>(this, 'currency') as String?;
  @override
  set currency(String? value) => RealmObjectBase.set(this, 'currency', value);

  @override
  bool get isDefault => RealmObjectBase.get<bool>(this, 'isDefault') as bool;
  @override
  set isDefault(bool value) => RealmObjectBase.set(this, 'isDefault', value);

  @override
  bool get isReport => RealmObjectBase.get<bool>(this, 'isReport') as bool;
  @override
  set isReport(bool value) => RealmObjectBase.set(this, 'isReport', value);

  @override
  Stream<RealmObjectChanges<WalletModel>> get changes =>
      RealmObjectBase.getChanges<WalletModel>(this);

  @override
  WalletModel freeze() => RealmObjectBase.freezeObject<WalletModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(WalletModel._);
    return const SchemaObject(
        ObjectType.realmObject, WalletModel, 'WalletModel', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('index', RealmPropertyType.int),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('icon', RealmPropertyType.string, optional: true),
      SchemaProperty('balance', RealmPropertyType.double, optional: true),
      SchemaProperty('currency', RealmPropertyType.string, optional: true),
      SchemaProperty('isDefault', RealmPropertyType.bool),
      SchemaProperty('isReport', RealmPropertyType.bool),
    ]);
  }
}
