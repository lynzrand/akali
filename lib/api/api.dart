import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:rpc/rpc.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:akali/data/db.dart';
import 'package:akali/data/pic.dart';

/// Akali's default API.
@ApiClass(
  name: 'api',
  version: 'v1',
)
class AkaliApi {
  /// Database that this API connects on.
  AkaliDatabase db;

  String fileStoragePath;

  AkaliApi({
    this.db,
    this.fileStoragePath,
  });

  /// GETs a picture by the following criteria:
  ///
  /// List separated with "+": [tags], [author]
  ///
  /// Integers: [minWidth], [maxWidth], [minHeight], [maxHeight]
  @ApiMethod(name: 'Search image by query', method: 'GET', path: 'img')
  // Future<List<Pic>> getPicByQuery({
  // ## Current workaround: call custon toJson() and return a string, instead of
  // returning the object and let rpc do the job.
  Future<MediaMessage> listPicByQuery({
    String tags,
    String author,
    int minWidth,
    int maxWidth,
    int minHeight,
    int maxHeight,
    String minAspectRatioStr,
    String maxAspectRatioStr,
    bool pretty = false,
  }) async {
    List<String> tagsList;
    List<String> authorList;
    double minAspectRatio;
    double maxAspectRatio;
    try {
      // Please note that seen by the server, query "xxx+yyy" is the same as "xxx yyy".
      tagsList = tags?.split(" ");
      authorList = author?.split(" ");
      if (minAspectRatioStr != null)
        minAspectRatio = double.tryParse(minAspectRatioStr);
      if (maxAspectRatioStr != null)
        maxAspectRatio = double.tryParse(maxAspectRatioStr);
    } catch (e, stacktrace) {
      throw BadRequestError(e.toString() + "\n" + stacktrace.toString());
    }
    Map<String, dynamic> searchQuery = {};

    // Search for specific tags
    if (tagsList?.isNotEmpty ?? false)
      searchQuery["tags"] = {"\$all": tagsList};

    try {
      var searchResults = await db.picCollection
          .find(searchQuery)
          // .map((i) => Pic.fromMap(i))
          // .map((i) => jsonEncode(i))
          .toList();
      return MediaMessage()
        ..bytes = JsonUtf8Encoder(pretty ? "  " : null).convert(searchResults);
    } catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  @ApiMethod(name: 'Get image from file', method: 'GET', path: 'img/get/{id}')
  Future<MediaMessage> getImageFile(String id) async {
    // TODO: add file manager for remote file redirections if needed
    var file = File('$fileStoragePath/img/$id.png');
    if (!await file.exists()) {
      throw BadRequestError('Image with id=$id does not exist!');
    }
    var msg = MediaMessage()..bytes = file.readAsBytesSync();
    return msg;
  }

  @ApiMethod(name: 'Post image data', method: 'POST', path: 'img/data/{token}')
  Future<VoidMessage> postImageData(String token, Pic pic) async {
    await db.postImageData(pic);
    return VoidMessage();
  }

  @ApiMethod(name: 'Post image file', method: 'PUT', path: 'img')
  Future<ImagePostRequestResponse> postImageFile(List<int> blob) async {
    String blobLink = '$fileStoragePath/img';
    // TODO: put blob to some link
    var token = await db.addPendingImage(blobLink);
    var file = File('$blobLink/$token.png');
    await file.create();
    await file.writeAsBytes(blob);
    blobLink = file.path; // for DEBUG use.
    return ImagePostRequestResponse()
      ..token = token
      ..imageLink = blobLink;
  }
}

class ImagePostRequestResponse {
  String token;
  String imageLink;
}
