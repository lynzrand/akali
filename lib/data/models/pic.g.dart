// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pic _$PicFromJson(Map<String, dynamic> json) {
  return Pic()
    ..id = json['_id'] == null ? null : objectIdFromMap(json['_id'] as String)
    ..title = json['title'] as String
    ..desc = json['desc'] as String
    ..author = json['author'] as String
    ..uploaderId = json['uploaderId'] as String
    ..original = json['original'] == null
        ? null
        : ImageInformation.fromJson(json['original'])
    ..compressed = json['compressed'] == null
        ? null
        : ImageInformation.fromJson(json['compressed'])
    ..preview = json['preview'] == null
        ? null
        : ImageInformation.fromJson(json['preview'])
    ..tags = (json['tags'] as List)
        ?.map((e) => e == null ? null : Tag.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PicToJson(Pic instance) => <String, dynamic>{
      '_id': instance.id == null ? null : objectIdToMap(instance.id),
      'title': instance.title,
      'desc': instance.desc,
      'author': instance.author,
      'uploaderId': instance.uploaderId,
      'original': instance.original,
      'compressed': instance.compressed,
      'preview': instance.preview,
      'tags': instance.tags
    };

ImageInformation _$ImageInformationFromJson(Map<String, dynamic> json) {
  return ImageInformation(
      width: json['width'] as int,
      height: json['height'] as int,
      ext: json['ext'] as String,
      fileId: json['fileId'] == null
          ? null
          : objectIdFromMap(json['fileId'] as String),
      fileSize: json['fileSize'] as int,
      link: json['link'] as String);
}

Map<String, dynamic> _$ImageInformationToJson(ImageInformation instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'fileSize': instance.fileSize,
      'link': instance.link,
      'fileId': instance.fileId == null ? null : objectIdToMap(instance.fileId),
      'ext': instance.ext
    };
