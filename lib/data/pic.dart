import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:rpc/rpc.dart';

class Pic {
  /// Unique identifier of the picture.
  /// Should contain timestamp according to MongoDB's configuration.
  ///
  /// If you use other databases, you must manually add a timestamp property
  /// instead of using [timestamp].
  @ApiProperty(ignore: true)
  ObjectId id;

  @ApiProperty()
  String get identifier {
    return id.toHexString();
  }

  /// title of the picture
  String title;

  /// Additional description of the picture
  String desc;

  /// The one who drew this pic.
  String author;

  /// The ID of the uploader
  int uploaderId;

  /// link to the picture
  ///
  /// Should be a full link for convinience. If you would like to use a
  /// relative link, please use _link as the property name and write your own
  /// get link method.
  String link;

  /// File size in bytes.
  int fileSize;

  /// image width
  int width;

  /// image height
  int height;

  /// image aspect ratio
  double get aspectRatio {
    return width / height;
  }

  /// link to the preview image
  String previewLink;

  /// preview width
  int previewWidth;

  /// preview height
  int previewHeight;

  /// tags
  List<String> tags;

  DateTime get timestamp {
    return id.dateTime;
  }

  Map<String, dynamic> toMap() {
    return {
      "_id": id?.toHexString(),
      "title": title,
      "desc": desc,
      "author": author,
      "uploaderId": uploaderId,
      "link": link,
      "fileSize": fileSize,
      "width": width,
      "height": height,
      "previewLink": previewLink,
      "previewWidth": previewWidth,
      "previewHeight": previewHeight,
      "tags": tags,
    };
  }

  String toJson() {
    return jsonEncode(this.toMap());
  }

  Pic.fromMap(Map<String, dynamic> map) {
    id = map['_id'] != null ? ObjectId.fromHexString(map['_id']) : ObjectId(clientMode: true);
    title = map['title'];
    desc = map['desc'];
    author = map['author'];
    uploaderId = map['uploaderId'];
    link = map['link'];
    width = map['width'];
    height = map['height'];
    previewLink = map['previewLink'];
    previewWidth = map['previewWidth'];
    previewHeight = map['previewHeight'];
    tags = map['tags'];
  }

  Pic();
}

enum ImageRating { safe, questionable, explicit }
