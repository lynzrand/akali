// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'results.dart';

// **************************************************************************
// DsonGenerator
// **************************************************************************

abstract class _$ActionResultSerializable<T> extends SerializableMap {
  bool get success;
  int get affected;
  String get message;
  T get data;
  void set success(bool v);
  void set affected(int v);
  void set message(String v);
  void set data(T v);

  operator [](Object __key) {
    switch (__key) {
      case 'success':
        return success;
      case 'affected':
        return affected;
      case 'message':
        return message;
      case 'data':
        return data;
    }
    throwFieldNotFoundException(__key, 'ActionResult');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case 'success':
        success = __value;
        return;
      case 'affected':
        affected = __value;
        return;
      case 'message':
        message = __value;
        return;
      case 'data':
        data = __value;
        return;
    }
    throwFieldNotFoundException(__key, 'ActionResult');
  }

  Iterable<String> get keys => ActionResultClassMirror.fields.keys;
}

abstract class _$SearchResultSerializable<T> extends SerializableMap {
  int get count;
  int get skip;
  int get total;
  List<T> get result;
  void set count(int v);
  void set skip(int v);
  void set total(int v);
  void set result(List<T> v);

  operator [](Object __key) {
    switch (__key) {
      case 'count':
        return count;
      case 'skip':
        return skip;
      case 'total':
        return total;
      case 'result':
        return result;
    }
    throwFieldNotFoundException(__key, 'SearchResult');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case 'count':
        count = __value;
        return;
      case 'skip':
        skip = __value;
        return;
      case 'total':
        total = __value;
        return;
      case 'result':
        result = fromSerialized(__value, () => new List<T>());
        return;
    }
    throwFieldNotFoundException(__key, 'SearchResult');
  }

  Iterable<String> get keys => SearchResultClassMirror.fields.keys;
}

// **************************************************************************
// MirrorsGenerator
// **************************************************************************

_ActionResult__Constructor([positionalParams, namedParams]) =>
    new ActionResult();

const $$ActionResult_fields_success =
    const DeclarationMirror(name: 'success', type: bool);
const $$ActionResult_fields_affected =
    const DeclarationMirror(name: 'affected', type: int);
const $$ActionResult_fields_message =
    const DeclarationMirror(name: 'message', type: String);
const $$ActionResult_fields_data =
    const DeclarationMirror(name: 'data', type: dynamic);

const ActionResultClassMirror =
    const ClassMirror(name: 'ActionResult', constructors: const {
  '': const FunctionMirror(name: '', $call: _ActionResult__Constructor)
}, fields: const {
  'success': $$ActionResult_fields_success,
  'affected': $$ActionResult_fields_affected,
  'message': $$ActionResult_fields_message,
  'data': $$ActionResult_fields_data
}, getters: const [
  'success',
  'affected',
  'message',
  'data'
], setters: const [
  'success',
  'affected',
  'message',
  'data'
]);

_SearchResult__Constructor([positionalParams, namedParams]) =>
    new SearchResult();

const $$SearchResult_fields_count =
    const DeclarationMirror(name: 'count', type: int);
const $$SearchResult_fields_skip =
    const DeclarationMirror(name: 'skip', type: int);
const $$SearchResult_fields_total =
    const DeclarationMirror(name: 'total', type: int);
const $$SearchResult_fields_result =
    const DeclarationMirror(name: 'result', type: const [List, dynamic]);

const SearchResultClassMirror =
    const ClassMirror(name: 'SearchResult', constructors: const {
  '': const FunctionMirror(name: '', $call: _SearchResult__Constructor)
}, fields: const {
  'count': $$SearchResult_fields_count,
  'skip': $$SearchResult_fields_skip,
  'total': $$SearchResult_fields_total,
  'result': $$SearchResult_fields_result
}, getters: const [
  'count',
  'skip',
  'total',
  'result'
], setters: const [
  'count',
  'skip',
  'total',
  'result'
]);
