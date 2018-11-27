import 'dart:io';
import 'dart:convert';

// TODO: finish this!

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

  /// Whether Akali is running in Debug Mode
  bool debug = false;

  /// The name of the picture collection
  ///
  /// TODO: change this.
  static String pictureCollectionName = 'pic';
}
