// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TransactionModel.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class TransactionModel extends _TransactionModel
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  TransactionModel(
    String id,
    int walletId,
    int groupId, {
    String? title,
    double? amount,
    String? unit = "VND",
    String? type = "income",
    String? date,
    String? note,
    bool? addToReport = true,
    String? notifyDate,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<TransactionModel>({
        'unit': "VND",
        'type': "income",
        'addToReport': true,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'unit', unit);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'note', note);
    RealmObjectBase.set(this, 'addToReport', addToReport);
    RealmObjectBase.set(this, 'notifyDate', notifyDate);
    RealmObjectBase.set(this, 'walletId', walletId);
    RealmObjectBase.set(this, 'groupId', groupId);
  }

  TransactionModel._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get title => RealmObjectBase.get<String>(this, 'title') as String?;
  @override
  set title(String? value) => RealmObjectBase.set(this, 'title', value);

  @override
  double? get amount => RealmObjectBase.get<double>(this, 'amount') as double?;
  @override
  set amount(double? value) => RealmObjectBase.set(this, 'amount', value);

  @override
  String? get unit => RealmObjectBase.get<String>(this, 'unit') as String?;
  @override
  set unit(String? value) => RealmObjectBase.set(this, 'unit', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get date => RealmObjectBase.get<String>(this, 'date') as String?;
  @override
  set date(String? value) => RealmObjectBase.set(this, 'date', value);

  @override
  String? get note => RealmObjectBase.get<String>(this, 'note') as String?;
  @override
  set note(String? value) => RealmObjectBase.set(this, 'note', value);

  @override
  bool? get addToReport =>
      RealmObjectBase.get<bool>(this, 'addToReport') as bool?;
  @override
  set addToReport(bool? value) =>
      RealmObjectBase.set(this, 'addToReport', value);

  @override
  String? get notifyDate =>
      RealmObjectBase.get<String>(this, 'notifyDate') as String?;
  @override
  set notifyDate(String? value) =>
      RealmObjectBase.set(this, 'notifyDate', value);

  @override
  int get walletId => RealmObjectBase.get<int>(this, 'walletId') as int;
  @override
  set walletId(int value) => RealmObjectBase.set(this, 'walletId', value);

  @override
  int get groupId => RealmObjectBase.get<int>(this, 'groupId') as int;
  @override
  set groupId(int value) => RealmObjectBase.set(this, 'groupId', value);

  @override
  Stream<RealmObjectChanges<TransactionModel>> get changes =>
      RealmObjectBase.getChanges<TransactionModel>(this);

  @override
  TransactionModel freeze() =>
      RealmObjectBase.freezeObject<TransactionModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(TransactionModel._);
    return const SchemaObject(
        ObjectType.realmObject, TransactionModel, 'TransactionModel', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string, optional: true),
      SchemaProperty('amount', RealmPropertyType.double, optional: true),
      SchemaProperty('unit', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('date', RealmPropertyType.string, optional: true),
      SchemaProperty('note', RealmPropertyType.string, optional: true),
      SchemaProperty('addToReport', RealmPropertyType.bool, optional: true),
      SchemaProperty('notifyDate', RealmPropertyType.string, optional: true),
      SchemaProperty('walletId', RealmPropertyType.int),
      SchemaProperty('groupId', RealmPropertyType.int),
    ]);
  }
}
