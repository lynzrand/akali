import 'package:json_annotation/json_annotation.dart';
part 'results.g.dart';

@JsonSerializable()
class ActionResult<T> {
  bool success;
  int affected;
  String message;
  @JsonKey(fromJson: _unchangedDataWrapper, toJson: _unchangedDataWrapper)
  T data;
}

@JsonSerializable()
class SearchResult<T> {
  int count;
  int skip;
  int total;
  @JsonKey(fromJson: _unchangedListWrapper, toJson: _unchangedListWrapper)
  List<T> result;
}

T _unchangedDataWrapper<T>(T data) => data;

List _unchangedListWrapper<List>(List data) => data;
