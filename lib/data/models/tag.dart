import 'package:dson/dson.dart';
import 'package:meta/meta.dart';

part 'tag.g.dart';

@serializable
class Tag {
  String name;
  String type;
  String description;
  Tag({this.name, this.type, this.description});
}
