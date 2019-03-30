import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'package:aqueduct/aqueduct.dart' as _aqueduct;
import 'package:akali/data/helpers/aqueductImporter.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag extends _aqueduct.Serializable {
  String name;
  String type;
  String desc;
  Tag({this.name, this.type, this.desc});

  @override
  void readFromMap(Map<String, dynamic> object) {
    this.name = object['name'];
    this.type = object['type'];
    this.desc = object['desc'];
  }

  @override
  Map<String, dynamic> asMap() => _$TagToJson(this);
  Map<String, dynamic> toJson() => _$TagToJson(this);

  factory Tag.fromMap(Map<String, dynamic> map) => _$TagFromJson(map);
  factory Tag.fromJson(Map<String, dynamic> map) => _$TagFromJson(map);

  // static toJson(Tag tag) => _$TagToJson(tag);
}
