// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configLoader.dart';

// **************************************************************************
// DsonGenerator
// **************************************************************************

abstract class _$AkaliConfigSerializable extends SerializableMap {
  Level get verbosity;
  String get webRoot;
  String get fileSystemRoot;
  String get databaseUri;
  int get port;
  int get isolateNum;
  void set verbosity(Level v);
  void set webRoot(String v);
  void set fileSystemRoot(String v);
  void set databaseUri(String v);
  void set port(int v);
  void set isolateNum(int v);

  operator [](Object __key) {
    switch (__key) {
      case 'verbosity':
        return verbosity;
      case 'webRoot':
        return webRoot;
      case 'fileSystemRoot':
        return fileSystemRoot;
      case 'databaseUri':
        return databaseUri;
      case 'port':
        return port;
      case 'isolateNum':
        return isolateNum;
    }
    throwFieldNotFoundException(__key, 'AkaliConfig');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case 'verbosity':
        verbosity = fromSerialized(
            __value, () => new Level(__value['name'], __value['value']));
        return;
      case 'webRoot':
        webRoot = __value;
        return;
      case 'fileSystemRoot':
        fileSystemRoot = __value;
        return;
      case 'databaseUri':
        databaseUri = __value;
        return;
      case 'port':
        port = __value;
        return;
      case 'isolateNum':
        isolateNum = __value;
        return;
    }
    throwFieldNotFoundException(__key, 'AkaliConfig');
  }

  Iterable<String> get keys => AkaliConfigClassMirror.fields.keys;
}

// **************************************************************************
// MirrorsGenerator
// **************************************************************************

_AkaliConfig__Constructor([positionalParams, namedParams]) => new AkaliConfig(
    verbosity: namedParams['verbosity'],
    webRoot: namedParams['webRoot'],
    fileSystemRoot: namedParams['fileSystemRoot'],
    databaseUri: namedParams['databaseUri'],
    port: namedParams['port'],
    isolateNum: namedParams['isolateNum']);

const $$AkaliConfig_fields_verbosity =
    const DeclarationMirror(name: 'verbosity', type: Level);
const $$AkaliConfig_fields_webRoot =
    const DeclarationMirror(name: 'webRoot', type: String);
const $$AkaliConfig_fields_fileSystemRoot =
    const DeclarationMirror(name: 'fileSystemRoot', type: String);
const $$AkaliConfig_fields_databaseUri =
    const DeclarationMirror(name: 'databaseUri', type: String);
const $$AkaliConfig_fields_port =
    const DeclarationMirror(name: 'port', type: int);
const $$AkaliConfig_fields_isolateNum =
    const DeclarationMirror(name: 'isolateNum', type: int);

const AkaliConfigClassMirror =
    const ClassMirror(name: 'AkaliConfig', constructors: const {
  '': const FunctionMirror(
      name: '',
      namedParameters: const {
        'verbosity': const DeclarationMirror(
            name: 'verbosity', type: Level, isNamed: true),
        'webRoot': const DeclarationMirror(
            name: 'webRoot', type: String, isNamed: true),
        'fileSystemRoot': const DeclarationMirror(
            name: 'fileSystemRoot', type: String, isNamed: true),
        'databaseUri': const DeclarationMirror(
            name: 'databaseUri', type: String, isNamed: true),
        'port': const DeclarationMirror(name: 'port', type: int, isNamed: true),
        'isolateNum': const DeclarationMirror(
            name: 'isolateNum', type: int, isNamed: true)
      },
      $call: _AkaliConfig__Constructor)
}, fields: const {
  'verbosity': $$AkaliConfig_fields_verbosity,
  'webRoot': $$AkaliConfig_fields_webRoot,
  'fileSystemRoot': $$AkaliConfig_fields_fileSystemRoot,
  'databaseUri': $$AkaliConfig_fields_databaseUri,
  'port': $$AkaliConfig_fields_port,
  'isolateNum': $$AkaliConfig_fields_isolateNum
}, getters: const [
  'verbosity',
  'webRoot',
  'fileSystemRoot',
  'databaseUri',
  'port',
  'isolateNum'
], setters: const [
  'verbosity',
  'webRoot',
  'fileSystemRoot',
  'databaseUri',
  'port',
  'isolateNum'
]);
