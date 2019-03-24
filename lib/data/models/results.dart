import 'package:dson/dson.dart';

part 'results.g.dart';

@serializable
class ActionResult<T> {
  bool success;
  int affected;
  String message;
  T data;
}

@serializable
class SearchResult<T> {
  int count;
  int skip;
  int total;
  List<T> result;
}
