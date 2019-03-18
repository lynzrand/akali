import 'dart:io';

import 'package:logging/logging.dart';
import 'package:dson/dson.dart';
import 'package:yaml/yaml.dart';

part "configLoader.g.dart";

@serializable
class AkaliConfig {
  Level verbosity;
  String webRoot;
  String fileSystemRoot;
  String databaseUri;
  int port;
  int isolateNum;

  AkaliConfig({
    this.verbosity,
    this.webRoot,
    this.fileSystemRoot,
    this.databaseUri,
    this.port,
    this.isolateNum,
  });
}

AkaliConfig configLoader(String file) {
  return fromMap(
      loadYaml(File.fromUri(Uri.file(file)).readAsStringSync()), AkaliConfig);
}
