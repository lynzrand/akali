// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionResult<T> _$ActionResultFromJson<T>(Map<String, dynamic> json) {
  return ActionResult<T>()
    ..success = json['success'] as bool
    ..affected = json['affected'] as int
    ..message = json['message'] as String
    ..data = json['data'] == null ? null : unchangedDataWrapper(json['data']);
}

Map<String, dynamic> _$ActionResultToJson<T>(ActionResult<T> instance) =>
    <String, dynamic>{
      'success': instance.success,
      'affected': instance.affected,
      'message': instance.message,
      'data': instance.data == null ? null : unchangedDataWrapper(instance.data)
    };

SearchResult<T> _$SearchResultFromJson<T>(Map<String, dynamic> json) {
  return SearchResult<T>()
    ..count = json['count'] as int
    ..skip = json['skip'] as int
    ..total = json['total'] as int
    ..result = json['result'] == null
        ? null
        : unchangedListWrapper(json['result'] as List);
}

Map<String, dynamic> _$SearchResultToJson<T>(SearchResult<T> instance) =>
    <String, dynamic>{
      'count': instance.count,
      'skip': instance.skip,
      'total': instance.total,
      'result':
          instance.result == null ? null : unchangedListWrapper(instance.result)
    };
