import 'package:dson/dson.dart';
import 'package:meta/meta.dart';

import 'package:aqueduct/aqueduct.dart' as _aqueduct;
import 'package:akali/data/helpers/aqueductImporter.dart';

part 'tag.g.dart';

@serializable
class Tag extends _aqueduct.Serializable {
  String name;
  String type;
  String desc;
  Tag({this.name, this.type, this.desc});

  @override
  Map<String, dynamic> asMap() {
    // return {"name": this.name, "type": this.type, "desc": this.desc};
    return toMap(this);
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    this.name = object['name'];
    this.type = object['type'];
    this.desc = object['desc'];
  }
}
