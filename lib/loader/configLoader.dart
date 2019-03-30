import 'dart:io';

import 'package:akali/data/helpers/jsonConversionHelpers.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';

import 'package:yaml/yaml.dart';

part "configLoader.g.dart";

@JsonSerializable()
class AkaliConfig {
  @JsonKey(fromJson: levelFromMap, toJson: levelToMap)
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
