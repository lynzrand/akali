// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configLoader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AkaliConfig _$AkaliConfigFromJson(Map<String, dynamic> json) {
  return AkaliConfig(
      verbosity: json['verbosity'] == null
          ? null
          : levelFromMap(json['verbosity'] as Map<String, dynamic>),
      webRoot: json['webRoot'] as String,
      fileSystemRoot: json['fileSystemRoot'] as String,
      databaseUri: json['databaseUri'] as String,
      port: json['port'] as int,
      isolateNum: json['isolateNum'] as int);
}

Map<String, dynamic> _$AkaliConfigToJson(AkaliConfig instance) =>
    <String, dynamic>{
      'verbosity':
          instance.verbosity == null ? null : levelToMap(instance.verbosity),
      'webRoot': instance.webRoot,
      'fileSystemRoot': instance.fileSystemRoot,
      'databaseUri': instance.databaseUri,
      'port': instance.port,
      'isolateNum': instance.isolateNum
    };
