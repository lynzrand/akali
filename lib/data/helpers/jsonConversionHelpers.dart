import 'package:aqueduct/aqueduct.dart';
import 'package:bson/bson.dart';
import 'package:logging/logging.dart';

ObjectId objectIdFromMap(String id) {
  return ObjectId.fromHexString(id);
}

String objectIdToMap(ObjectId id) {
  return id.toHexString();
}

Level levelFromMap(Map<String, dynamic> map) {
  return Level(map['name'], map['value']);
}

Map<String, dynamic> levelToMap(Level level) {
  return {
    "name": level.name,
    "level": level.value,
  };
}

List<String> authScopeToMap(List<AuthScope> scopes) {
  return scopes.map((scope) => scope.toString());
}

List<AuthScope> authScopeFromMap(List<String> scopes) {
  return scopes.map((s) => AuthScope(s));
}

Map<String, dynamic> objectIdStringifier(Map<String, dynamic> origin) {
  if (origin['_id'] != null && origin['_id'] is ObjectId)
    origin['_id'] = (origin['_id'] as ObjectId).toHexString();
  return origin;
}

Map<String, dynamic> objectIdDestringifier(Map<String, dynamic> origin) {
  if (origin['_id'] != null && origin['_id'] is String)
    origin['_id'] = ObjectId.fromHexString(origin['_id'] as String);
  return origin;
}

dynamic unchangedDataWrapper(data) => data;

List unchangedListWrapper<List>(List data) => data;

List<dynamic> listMapTransformationWrapper(List<dynamic> objects) =>
    objects.map((o) => o.toJson()).toList();
