import 'dart:convert';
import 'package:aqueduct/aqueduct.dart' as _aqueduct;
import 'package:akali/data/models/tag.dart';
import 'package:akali/data/helpers/aqueductImporter.dart';

import 'package:dson/dson.dart';
import 'package:mongo_dart/mongo_dart.dart';
part "pic.g.dart";

@serializable
class Pic extends _aqueduct.Serializable {
  // UUID of the pictures
  @SerializedName("_id")
  ObjectId id;

  /// title of the picture
  String title;

  /// Additional description of the picture
  String desc;

  /// The one who drew this pic.
  String author;

  /// The ID of the uploader
  String uploaderId;

  /// Information of the original image
  ImageInformation original;

  /// Information of the compressed (JPEG) image
  ImageInformation compressed;

  /// Information of the preview image
  ImageInformation preview;

  /// tags
  List<Tag> tags;

  // /// timestamp
  // DateTime dueDate;

  /// return mapped information
  Map<String, dynamic> asMap() {
    var result = toMap(this);
    if (result['_id'] != null) result['_id'] = result['_id'].toString();
    return result;
  }

  String toJson() {
    return jsonEncode(this.asMap());
  }

  String toString() {
    return this.toString();
  }

  Pic();

  void readFromMap(Map<String, dynamic> map) {
    if (map['_id'] != null && map['_id'] is String)
      map['_id'] = ObjectId.fromHexString(map['_id']);

    this.id = map['_id'] ?? map['id'];
    this.title = map['title'];
    this.desc = map['desc'];
    this.author = map['author'];
    this.uploaderId = map['uploaderId'];
    this.compressed = fromMap(map['compressed'], ImageInformation);
    this.original = fromMap(map['compressed'], ImageInformation);
    this.preview = fromMap(map['compressed'], ImageInformation);
    this.tags =
        fromSerialized(map['tags'], [() => new List<Tag>(), () => new Tag()]);
  }
}

@serializable
class ImageInformation extends _aqueduct.Serializable {
  /// Width of the image
  int width;

  /// Height of the image
  int height;

  /// Size of the image, in bytes.
  ///
  /// Hope no one will make images larger than 2^53 bytes(...)
  int fileSize;

  /// Link of the image
  String link;

  /// ID of the file; Used by GridFS
  ObjectId fileId;

  /// Extension of the image
  String ext;

  double get aspectRatio {
    return width.toDouble() / height;
  }

  String toJson() {
    return jsonEncode(this.asMap());
  }

  @override
  Map<String, dynamic> asMap() {
    return toMap(this);
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    // TODO: implement readFromMap
  }
}

enum ImageRating { safe, questionable, explicit }

enum ImageOrientation { horizontal, vertical, square, any }

class CriteriaTween<T> {
  T min;
  T max;
  CriteriaTween({this.min, this.max});
}

class ImageSearchCriteria {
  CriteriaTween<int> width;
  CriteriaTween<int> height;
  CriteriaTween<double> aspectRatio;
  List<String> tags;
  List<String> authors;

  ImageSearchCriteria() {}

  // Map<String, dynamic> asMongoDBQuery() {
  //   return {
  //     'tags': {'\$all': tags},
  //     'author': {'\$any': authors},
  //   };
  // }

  static const int breakpointSmallPic = 960;
  static const int breakpointMediumPic = 1080;
  static const int breakpointLargePic = 1440;

  // aspectRatio = width / height
  static const double breakpointLandscape = 1.09;
  static const double breakpointPortrait = 0.9;

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

  ImageSearchCriteria orientation(ImageOrientation _) {
    switch (_) {
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
