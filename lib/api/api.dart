import 'dart:async';
import 'dart:io';

import 'package:rpc/rpc.dart';

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

  AkaliApi(this.db);

  /// **NOT YET IMPLEMENTED.** GETs a picture by the following criteria:
  ///
  /// List separated with "+": [tags], [author]
  ///
  /// Integers: [minWidth], [maxWidth], [minHeight], [maxHeight]
  @ApiMethod(name: 'Search image by query', method: 'GET', path: 'img')
  Future<List<Pic>> getPicByQuery({
    // Future<Map<String, String>> listPicByQuery({
    String tags,
    String author,
    int minWidth,
    int maxWidth,
    int minHeight,
    int maxHeight,
    String minAspectRatioStr,
    String maxAspectRatioStr,
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
    var searchResults =
        await db.picCollection.find({"tags": tagsList}).toList();
    return searchResults.map((i) => Pic.fromMap(i)).toList();
  }

  @ApiMethod(name: 'Post image', method: 'POST', path: 'img')
  Future<VoidMessage> postImageData(Pic pic) async {
    await db.postImageData(pic);
    return VoidMessage();
  }
}
