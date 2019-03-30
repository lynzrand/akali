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
