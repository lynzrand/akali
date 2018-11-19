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

  /// **NOT YET IMPLEMENTED.** GETs a picture by the criteria [crit].
  @ApiMethod(name: 'Search image by query', method: 'GET', path: 'img')
  Future<List<Pic>> getPicByQuery({
    // Future<Map<String, String>> listPicByQuery({
    String tagsStr,
    String authorStr,
    int minWidth,
    int maxWidth,
    int minHeight,
    int maxHeight,
    String minAspectRatioStr,
    String maxAspectRatioStr,
  }) async {
    List<String> tags;
    List<String> author;
    double minAspectRatio;
    double maxAspectRatio;
    try {
      tags = tagsStr?.split("+");
      author = authorStr?.split("+");
      if (minAspectRatioStr != null) minAspectRatio = double.tryParse(minAspectRatioStr);
      if (maxAspectRatioStr != null) maxAspectRatio = double.tryParse(maxAspectRatioStr);
    } catch (e, stacktrace) {
      throw BadRequestError(e.toString() + "\n" + stacktrace.toString());
    }
    // DEBUG: TEST RESPONSE!
    // TODO: implement business logic
    return <Pic>[
      Pic.fromMap({
        "author": "someAuthor",
        "_id": "badbeefbadc0ffeebad12345",
      })
    ];
  }

  @ApiMethod(name: 'Post image', method: 'POST', path: 'img')
  Future<VoidMessage> postImageData(Pic pic) async {
    await db.postImageData(pic);
    return VoidMessage();
  }
}
