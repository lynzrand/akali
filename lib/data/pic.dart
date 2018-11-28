import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:aqueduct/aqueduct.dart';

class Pic implements Serializable {
  /// Unique identifier of the picture.
  /// Should contain timestamp according to MongoDB's configuration.
  ///
  /// If you use other databases, you must manually add a timestamp property
  /// instead of using [timestamp].

  mongo.ObjectId _id;

  String get id {
    return _id.toHexString();
  }

  set id(value) {
    if (value == null)
      _id = mongo.ObjectId(clientMode: true);
    else if (value is mongo.ObjectId)
      _id = value;
    else if (value is String)
      _id = mongo.ObjectId.fromHexString(value);
    else
      throw ArgumentError.value(value);
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
    return _id.dateTime;
  }

  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.map();
  }

  Map<String, dynamic> asMap() {
    return {
      '_id': id,
      'title': title,
      'desc': desc,
      'author': author,
      'uploaderId': uploaderId,
      'link': link,
      'fileSize': fileSize,
      'width': width,
      'height': height,
      'previewLink': previewLink,
      'previewWidth': previewWidth,
      'previewHeight': previewHeight,
      'tags': tags,
    };
  }

  String toJson() {
    return jsonEncode(this.asMap());
  }

  String toString() {
    return this.toJson();
  }

  Pic.readFromMap(Map<String, dynamic> map) {
    id = map['_id'];
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
    if (map['tags'] != null) tags = List<String>.from(map['tags']);
  }

  void readFromMap(Map<String, dynamic> map) {
    id = map['_id'];
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
    if (map['tags'] != null) tags = List<String>.from(map['tags']);
  }

  Pic();
}

enum ImageRating { safe, questionable, explicit }

enum ImageOrientation { horizontal, vertical, square, any }

class CriteriaTween<T> {
  T min;
  T max;
  CriteriaTween({this.min, this.max});
}

class ImageSearchCriteria {
  // int width.min;
  // int maxWidth;
  // int height.min;
  // int maxHeight;
  // double minAspectRatio;
  // double maxAspectRatio;

  CriteriaTween<int> width;
  CriteriaTween<int> height;
  CriteriaTween<double> aspectRatio;

  List<String> tags;
  List<String> authors;

  ImageSearchCriteria() {
    width = CriteriaTween();
    height = CriteriaTween();
    aspectRatio = CriteriaTween();
    tags = [];
    authors = [];
  }

  Map<String, dynamic> asMongoDBQuery() {
    return {};
  }

  static const int breakpointSmallPic = 960;
  static const int breakpointMediumPic = 1080;
  static const int breakpointLargePic = 1440;

  // aspectRatio = width / height
  static const double breakpointLandscape = 1.05;
  static const double breakpointPortrait = 0.95;

  ImageSearchCriteria.mediumAndLarger({
    List<String> this.tags,
    List<String> this.authors,
  }) {
    width.min = breakpointSmallPic;
    height.min = breakpointSmallPic;
  }

  ImageSearchCriteria.largeAndLarger({
    List<String> this.tags,
    List<String> this.authors,
  }) {
    width.min = breakpointMediumPic;
    height.min = breakpointMediumPic;
  }

  ImageSearchCriteria.extraLarge({
    List<String> this.tags,
    List<String> this.authors,
  }) {
    width.min = breakpointLargePic;
    height.min = breakpointLargePic;
  }

  ImageSearchCriteria mediumAndLarger() {
    width.min = breakpointSmallPic;
    height.min = breakpointSmallPic;
    return this;
  }

  ImageSearchCriteria largeAndLarger() {
    width.min = breakpointMediumPic;
    height.min = breakpointMediumPic;
    return this;
  }

  ImageSearchCriteria extraLarge() {
    width.min = breakpointLargePic;
    height.min = breakpointLargePic;
    return this;
  }

  ImageSearchCriteria orientation(ImageOrientation o) {
    switch (o) {
      case ImageOrientation.any:
        break;
      case ImageOrientation.horizontal:
        aspectRatio.min = breakpointLandscape;
        break;
      case ImageOrientation.vertical:
        aspectRatio.max = breakpointPortrait;
        break;
      case ImageOrientation.square:
        aspectRatio.min = breakpointPortrait;
        aspectRatio.max = breakpointLandscape;
        break;
    }
    return this;
  }
}
