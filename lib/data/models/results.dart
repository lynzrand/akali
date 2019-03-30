import 'package:json_annotation/json_annotation.dart';
import 'package:akali/data/helpers/jsonConversionHelpers.dart';

part 'results.g.dart';

@JsonSerializable()
class ActionResult<T> {
  bool success;
  int affected;
  String message;
  @JsonKey(fromJson: unchangedDataWrapper, toJson: unchangedDataWrapper)
  T data;

  asMap() => _$ActionResultToJson(this);
  toJson() => _$ActionResultToJson(this);
}

@JsonSerializable()
class SearchResult<T> {
  int count;
  int skip;
  int total;
  @JsonKey(fromJson: unchangedListWrapper, toJson: unchangedListWrapper)
  List<T> result;

  asMap() => _$SearchResultToJson(this);
  toJson() => _$SearchResultToJson(this);
}
