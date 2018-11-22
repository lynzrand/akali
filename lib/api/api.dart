import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';

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
        ..bytes = jsonEncode(searchResults).codeUnits
        ..contentEncoding = "utf16";
    } catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  @ApiMethod(name: 'Post image', method: 'POST', path: 'img')
  Future<VoidMessage> postImageData(Pic pic) async {
    await db.postImageData(pic);
    return VoidMessage();
  }
}
