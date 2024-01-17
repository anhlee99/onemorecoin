// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupModel.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class GroupModel extends _GroupModel
    with RealmEntity, RealmObjectBase, RealmObject {
  GroupModel(
    int id,
    int index, {
    String? name,
    String? type,
    String? icon,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'icon', icon);
    RealmObjectBase.set(this, 'index', index);
  }

  GroupModel._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get icon => RealmObjectBase.get<String>(this, 'icon') as String?;
  @override
  set icon(String? value) => RealmObjectBase.set(this, 'icon', value);

  @override
  int get index => RealmObjectBase.get<int>(this, 'index') as int;
  @override
  set index(int value) => RealmObjectBase.set(this, 'index', value);

  @override
  Stream<RealmObjectChanges<GroupModel>> get changes =>
      RealmObjectBase.getChanges<GroupModel>(this);

  @override
  GroupModel freeze() => RealmObjectBase.freezeObject<GroupModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(GroupModel._);
    return const SchemaObject(
        ObjectType.realmObject, GroupModel, 'GroupModel', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('icon', RealmPropertyType.string, optional: true),
      SchemaProperty('index', RealmPropertyType.int),
    ]);
  }
}
