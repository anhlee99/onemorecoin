// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StorageStage.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class StorageStage extends _StorageStage
    with RealmEntity, RealmObjectBase, RealmObject {
  StorageStage(
    int id,
    String key, {
    String? value,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'key', key);
    RealmObjectBase.set(this, 'value', value);
  }

  StorageStage._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get key => RealmObjectBase.get<String>(this, 'key') as String;
  @override
  set key(String value) => RealmObjectBase.set(this, 'key', value);

  @override
  String? get value => RealmObjectBase.get<String>(this, 'value') as String?;
  @override
  set value(String? value) => RealmObjectBase.set(this, 'value', value);

  @override
  Stream<RealmObjectChanges<StorageStage>> get changes =>
      RealmObjectBase.getChanges<StorageStage>(this);

  @override
  StorageStage freeze() => RealmObjectBase.freezeObject<StorageStage>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(StorageStage._);
    return const SchemaObject(
        ObjectType.realmObject, StorageStage, 'StorageStage', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('key', RealmPropertyType.string),
      SchemaProperty('value', RealmPropertyType.string, optional: true),
    ]);
  }
}
