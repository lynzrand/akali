import 'dart:io';
import 'dart:convert';

class Configuration {
  /// Reads config from a **JSON file** [config]
  static Future<Configuration> fromFile(File config) async {
    var str = await config.readAsString();
    return Configuration.fromJSON(jsonDecode(str));
  }

  /// Assign a JSON dynamic object [jsonObject] to a Configuration
  Configuration.fromJSON(dynamic jsonObject) {}

  /// Create an empty configuration to assign properties afterwards.
  Configuration();

  bool debug = false;
}
