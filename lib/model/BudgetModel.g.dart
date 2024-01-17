// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BudgetModel.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class BudgetModel extends _BudgetModel
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  BudgetModel(
    int id,
    int walletId,
    int groupId, {
    String? title,
    double? budget,
    String? unit = "VND",
    String? type = "expense",
    String? fromDate,
    String? toDate,
    String? note,
    bool? isRepeat = false,
    String? budgetType = "month",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<BudgetModel>({
        'unit': "VND",
        'type': "expense",
        'isRepeat': false,
        'budgetType': "month",
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'budget', budget);
    RealmObjectBase.set(this, 'unit', unit);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'fromDate', fromDate);
    RealmObjectBase.set(this, 'toDate', toDate);
    RealmObjectBase.set(this, 'note', note);
    RealmObjectBase.set(this, 'isRepeat', isRepeat);
    RealmObjectBase.set(this, 'walletId', walletId);
    RealmObjectBase.set(this, 'groupId', groupId);
    RealmObjectBase.set(this, 'budgetType', budgetType);
  }

  BudgetModel._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get title => RealmObjectBase.get<String>(this, 'title') as String?;
  @override
  set title(String? value) => RealmObjectBase.set(this, 'title', value);

  @override
  double? get budget => RealmObjectBase.get<double>(this, 'budget') as double?;
  @override
  set budget(double? value) => RealmObjectBase.set(this, 'budget', value);

  @override
  String? get unit => RealmObjectBase.get<String>(this, 'unit') as String?;
  @override
  set unit(String? value) => RealmObjectBase.set(this, 'unit', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get fromDate =>
      RealmObjectBase.get<String>(this, 'fromDate') as String?;
  @override
  set fromDate(String? value) => RealmObjectBase.set(this, 'fromDate', value);

  @override
  String? get toDate => RealmObjectBase.get<String>(this, 'toDate') as String?;
  @override
  set toDate(String? value) => RealmObjectBase.set(this, 'toDate', value);

  @override
  String? get note => RealmObjectBase.get<String>(this, 'note') as String?;
  @override
  set note(String? value) => RealmObjectBase.set(this, 'note', value);

  @override
  bool? get isRepeat => RealmObjectBase.get<bool>(this, 'isRepeat') as bool?;
  @override
  set isRepeat(bool? value) => RealmObjectBase.set(this, 'isRepeat', value);

  @override
  int get walletId => RealmObjectBase.get<int>(this, 'walletId') as int;
  @override
  set walletId(int value) => RealmObjectBase.set(this, 'walletId', value);

  @override
  int get groupId => RealmObjectBase.get<int>(this, 'groupId') as int;
  @override
  set groupId(int value) => RealmObjectBase.set(this, 'groupId', value);

  @override
  String? get budgetType =>
      RealmObjectBase.get<String>(this, 'budgetType') as String?;
  @override
  set budgetType(String? value) =>
      RealmObjectBase.set(this, 'budgetType', value);

  @override
  Stream<RealmObjectChanges<BudgetModel>> get changes =>
      RealmObjectBase.getChanges<BudgetModel>(this);

  @override
  BudgetModel freeze() => RealmObjectBase.freezeObject<BudgetModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(BudgetModel._);
    return const SchemaObject(
        ObjectType.realmObject, BudgetModel, 'BudgetModel', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string, optional: true),
      SchemaProperty('budget', RealmPropertyType.double, optional: true),
      SchemaProperty('unit', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('fromDate', RealmPropertyType.string, optional: true),
      SchemaProperty('toDate', RealmPropertyType.string, optional: true),
      SchemaProperty('note', RealmPropertyType.string, optional: true),
      SchemaProperty('isRepeat', RealmPropertyType.bool, optional: true),
      SchemaProperty('walletId', RealmPropertyType.int),
      SchemaProperty('groupId', RealmPropertyType.int),
      SchemaProperty('budgetType', RealmPropertyType.string, optional: true),
    ]);
  }
}
