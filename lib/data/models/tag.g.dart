// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// DsonGenerator
// **************************************************************************

abstract class _$TagSerializable extends SerializableMap {
  String get name;
  String get type;
  String get description;
  void set name(String v);
  void set type(String v);
  void set description(String v);

  operator [](Object __key) {
    switch (__key) {
      case 'name':
        return name;
      case 'type':
        return type;
      case 'description':
        return description;
    }
    throwFieldNotFoundException(__key, 'Tag');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case 'name':
        name = __value;
        return;
      case 'type':
        type = __value;
        return;
      case 'description':
        description = __value;
        return;
    }
    throwFieldNotFoundException(__key, 'Tag');
  }

  Iterable<String> get keys => TagClassMirror.fields.keys;
}

// **************************************************************************
// MirrorsGenerator
// **************************************************************************

_Tag__Constructor([positionalParams, namedParams]) => new Tag(
    name: namedParams['name'],
    type: namedParams['type'],
    description: namedParams['description']);

const $$Tag_fields_name = const DeclarationMirror(name: 'name', type: String);
const $$Tag_fields_type = const DeclarationMirror(name: 'type', type: String);
const $$Tag_fields_description =
    const DeclarationMirror(name: 'description', type: String);

const TagClassMirror = const ClassMirror(name: 'Tag', constructors: const {
  '': const FunctionMirror(
      name: '',
      namedParameters: const {
        'name':
            const DeclarationMirror(name: 'name', type: String, isNamed: true),
        'type':
            const DeclarationMirror(name: 'type', type: String, isNamed: true),
        'description': const DeclarationMirror(
            name: 'description', type: String, isNamed: true)
      },
      $call: _Tag__Constructor)
}, fields: const {
  'name': $$Tag_fields_name,
  'type': $$Tag_fields_type,
  'description': $$Tag_fields_description
}, getters: const [
  'name',
  'type',
  'description'
], setters: const [
  'name',
  'type',
  'description'
]);
