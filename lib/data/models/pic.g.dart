// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pic _$PicFromJson(Map<String, dynamic> json) {
  return Pic()
    ..id = json['_id'] == null ? null : unchangedDataWrapper(json['_id'])
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

Map<String, dynamic> _$PicToJson(Pic instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      '_id', instance.id == null ? null : unchangedDataWrapper(instance.id));
  writeNotNull('title', instance.title);
  writeNotNull('desc', instance.desc);
  writeNotNull('author', instance.author);
  writeNotNull('uploaderId', instance.uploaderId);
  writeNotNull('original', instance.original);
  writeNotNull('compressed', instance.compressed);
  writeNotNull('preview', instance.preview);
  writeNotNull(
      'tags',
      instance.tags == null
          ? null
          : listMapTransformationWrapper(instance.tags));
  return val;
}

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
