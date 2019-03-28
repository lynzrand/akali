// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// DsonGenerator
// **************************************************************************

abstract class _$TagSerializable extends SerializableMap {
  String get name;
  String get type;
  String get desc;
  set name(String v);
  set type(String v);
  set desc(String v);
  Map<String, dynamic> asMap();
  void readFromMap(Map<String, dynamic> object);
  APISchemaObject documentSchema(APIDocumentContext context);
  void read(Map<String, dynamic> object,
      {Iterable<String> ignore,
      Iterable<String> reject,
      Iterable<String> require});

  operator [](Object __key) {
    switch (__key) {
      case 'name':
        return name;
      case 'type':
        return type;
      case 'desc':
        return desc;
      case 'asMap':
        return asMap;
      case 'readFromMap':
        return readFromMap;
      case 'documentSchema':
        return documentSchema;
      case 'read':
        return read;
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
      case 'desc':
        desc = __value;
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
    desc: namedParams['desc']);

const $$Tag_fields_name = const DeclarationMirror(name: 'name', type: String);
const $$Tag_fields_type = const DeclarationMirror(name: 'type', type: String);
const $$Tag_fields_desc = const DeclarationMirror(name: 'desc', type: String);

const TagClassMirror = const ClassMirror(
    name: 'Tag',
    constructors: const {
      '': const FunctionMirror(
          name: '',
          namedParameters: const {
            'name': const DeclarationMirror(
                name: 'name', type: String, isNamed: true),
            'type': const DeclarationMirror(
                name: 'type', type: String, isNamed: true),
            'desc': const DeclarationMirror(
                name: 'desc', type: String, isNamed: true)
          },
          $call: _Tag__Constructor)
    },
    fields: const {
      'name': $$Tag_fields_name,
      'type': $$Tag_fields_type,
      'desc': $$Tag_fields_desc
    },
    getters: const ['name', 'type', 'desc'],
    setters: const ['name', 'type', 'desc'],
    methods: const {
      'asMap': const FunctionMirror(
        name: 'asMap',
        returnType: const [
          Map,
          const [String, dynamic]
        ],
      ),
      'readFromMap': const FunctionMirror(
        positionalParameters: const [
          const DeclarationMirror(
              name: 'object',
              type: const [
                Map,
                const [String, dynamic]
              ],
              isRequired: true)
        ],
        name: 'readFromMap',
        returnType: null,
      ),
      'documentSchema': const FunctionMirror(
        positionalParameters: const [
          const DeclarationMirror(
              name: 'context', type: APIDocumentContext, isRequired: true)
        ],
        name: 'documentSchema',
        returnType: APISchemaObject,
      ),
      'read': const FunctionMirror(
        positionalParameters: const [
          const DeclarationMirror(
              name: 'object',
              type: const [
                Map,
                const [String, dynamic]
              ],
              isRequired: true)
        ],
        namedParameters: const {
          'ignore': const DeclarationMirror(
              name: 'ignore', type: const [Iterable, String], isNamed: true),
          'reject': const DeclarationMirror(
              name: 'reject', type: const [Iterable, String], isNamed: true),
          'require': const DeclarationMirror(
              name: 'require', type: const [Iterable, String], isNamed: true)
        },
        name: 'read',
        returnType: null,
      )
    },
    superclass: Serializable);
