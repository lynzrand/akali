import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:akali/models.dart';

import 'package:aqueduct/aqueduct.dart';

import 'fs.dart';
import 'oauth.dart';

class ImgRequestHandler extends ResourceController {
  AkaliDatabase db;
  AkaliFileManager fileManager;
  Logger logger;

  String webRootPath;

  ImgRequestHandler(this.db, this.fileManager, this.webRootPath) {
    this.logger = new Logger("akalihandle");
  }

  /// Workaround for handling special behaviors
  ///
  /// This method should only be used in special cases like
  /// dealing with an uploading file (...)
  @override
  FutureOr<RequestOrResponse> handle(Request request) async {
    // File uploading is redirected
    if ((request.method == 'POST' || request.method == 'PUT') &&
        request.path.variables['id'] == null) {
      return await _customHandleUploadImage(request);
    }
    // do the rest of handling
    return await super.handle(request);
  }

  /// GETs a picture by the following criteria:
  ///
  /// List separated with '+': [tags], [author]
  ///
  /// Integers: [minWidth], [maxWidth], [minHeight], [maxHeight]
  @Operation.get()
  Future<Response> listPicByQuery({
    @Bind.query('tags') String tags,
    @Bind.query('author') String author,
    @Bind.query('height') String height,
    @Bind.query('width') String width,
    @Bind.query('ratio') String ratio,
    @Bind.query('limit') int limit = 20,
    @Bind.query('skip') int skip = 0,
    @Bind.query('pretty') bool pretty = false,
  }) async {
    List<String> tagsList;
    List<String> authorList;
    CriteriaTween heightRange;
    CriteriaTween widthRange;
    CriteriaTween ratioRange;
    try {
      // Please note that seen by the server, query 'xxx+yyy' is the same as 'xxx yyy'.
      tagsList = _queryStringParser(tags);
      authorList = _queryStringParser(author);
      heightRange = _queryRangeParser(height);
      widthRange = _queryRangeParser(width);
      ratioRange = _queryRatioRangeParser(ratio);
    } catch (e, stacktrace) {
      throw Response.badRequest(body: {'error': e, 'stacktrace': stacktrace});
    }
    // Search for specific tags
    var searchQuery = ImageSearchCriteria()
      ..tags = tagsList
      ..authors = authorList
      ..height = heightRange
      ..width = widthRange
      ..aspectRatio = ratioRange;

    logger.log(Level.FINE, "Search image $searchQuery");

    try {
      var searchResults = await db.queryImg(searchQuery);
      if (pretty == false)
        return Response.ok(searchResults)..contentType = ContentType.json;
      else
        return Response.ok(Utf8Encoder().convert(
          JsonEncoder.withIndent('  ').convert(
              searchResults.result.map<Map<String, dynamic>>((p) => p.asMap())),
        ))
          ..contentType = ContentType.json
          ..encodeBody = false;
    } catch (e, stack) {
      logger.severe("Error when querying image: $e", e, stack);
      return Response.serverError(body: {
        'error': e,
        'message': 'Please report this to website admins!',
        'stackTrace': stack,
      });
    }
  }

  /// GET `/img/:id`
  ///
  /// GETs the information of image [id]
  @Operation.get('id')
  Future<Response> getImage(@Bind.path('id') String id) async {
    var result;
    try {
      // _id = ObjectId.fromHexString(id);
      result = await db.queryImgID(id);
    } catch (e, stack) {
      if (e is ArgumentError) {
        logger.info("Client requested bad ID $id", e, stack);
        throw Response.badRequest(body: {'error': 'Bad id number'});
      } else {
        logger.severe("Internal error when handling getImage()", e, stack);
        throw Response.serverError();
      }
    }
    return Response.ok(result)..contentType = ContentType.json;
  }

  /// POST `img/`
  ///
  /// A custom handler function for image uploading.
  /// Returns where to POST/PUT the image metadata.
  Future<Response> _customHandleUploadImage(Request upload) async {
    // if (upload.raw.headers.value('file-name') == null) {
    //   throw Response.badRequest(body: {"error": "File name not defined"});
    // } else
    if (upload.raw.headers.contentType.primaryType != 'image') {
      throw Response.badRequest(
          body: {"error": "You are not uploading an image"});
    }
    //TODO:: using UUID
    var id = ObjectId();
    var path;
    try {
      path = await fileManager.streamImageFileFrom(upload.body.bytes,
          id.toHexString() + '.' + upload.raw.headers.contentType.subType);
      // return Response.created(path.path);
      db.createImgId(id);
      return Response.ok({"success": true, "id": id});
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      throw Response.serverError(body: {
        "error": e,
        "message": "Please report this to the developers",
        'stacktrace': stackTrace,
      });
    }
  }

  // static final extensionParser = RegExp(r"(\..+?)$");

  // @Operation.get('id', 'operation')
  // Future<dynamic> operationWrapper(@Bind.path('id') String id,
  //     @Bind.path('operation') String operation) async {
  //   switch (operation) {
  //     case 'file':
  //       return await getImageFile(id);
  //     default:
  //       return Response.badRequest();
  //   }
  // }

  // Future<Response> getImageFile(String id) async {
  //   Stream<List<int>> fileStream;
  //   Pic pic;
  //   try {
  //     pic = await db.queryImgID(id);
  //   } catch (e) {
  //     throw Response.notFound();
  //   }
  //   var extension = extensionParser.firstMatch(pic.link).group(1);
  //   try {
  //     fileStream = await fileManager.streamFileTo(id, extension);
  //   } catch (e) {
  //     throw Response.serverError(body: e.toString());
  //   }
  //   try {
  //     return Response.ok(fileStream)
  //       ..encodeBody = false
  //       ..contentType = new ContentType('image', extension.substring(1));
  //   } catch (e) {
  //     throw Response.serverError(body: e.toString());
  //   }
  // }

  /// PUT `img/:id`
  ///
  /// Updates image [id]'s data by [newInfo].
  /// Requires authorization beforehand.
  @Operation.put('id')
  Future<Response> putImage(
    @Bind.path('id') String id,
    @Bind.body() Pic newInfo, [
    @Bind.query('access_token') String tokenQuery,
    @Bind.header('Access-Token') String tokenHeader,
  ]) async {
    var result;
    try {
      result = await db.updateImgInfo(newInfo, id);
    } catch (e, stack) {
      logger.severe("Error in putImage()", e, stack);
      throw Response.badRequest(
          body: {'error': e, 'message': result, 'stackTrace': stack});
    }
    return Response.ok(result);
  }

  /// DELETE `/img/:id`
  ///
  /// Deletes the coresponding image and its metadata
  @Operation.delete('id')
  Future<Response> deleteImageId(@Bind.path('id') String id) async {
    var result;
    try {
      await db.deleteImg(id);
    } catch (e, stack) {
      if (e is ArgumentError) {
        logger.info("Client requested bad ID $id", e, stack);
        throw Response.badRequest(body: {"error": "Bad id number"});
      } else {
        logger.severe("Internal error when handling deleteImage()", e, stack);
      }
    }
    return Response.ok({"success": true, "id": id});
  }

  List<String> _queryStringParser(String query) {
    return query?.split(' ');
  }

  CriteriaTween _queryRangeParser(String query) {
    CriteriaTween parser_result;
    List<String> parser_temp;
    parser_temp = query?.split(' ');
    if (parser_temp != null) {
      if (parser_temp.length == 1)
        parser_result.min = int.tryParse(parser_temp[0]);
      else if (parser_temp.length == 2) {
        parser_result.min = int.tryParse(parser_temp[0]);
        parser_result.max = int.tryParse(parser_temp[1]);
      }
    }
    return parser_result;
  }

  // Width / Height
  CriteriaTween _queryRatioRangeParser(String query) {
    CriteriaTween parser_result;
    List<String> parser_temp;
    parser_temp = query?.split(' ');
    if (parser_temp != null) {
      if (parser_temp.length == 2)
        parser_result.min =
            double.tryParse(parser_temp[0]) / double.tryParse(parser_temp[1]);
      else if (parser_temp.length == 4) {
        parser_result.min =
            double.tryParse(parser_temp[0]) / double.tryParse(parser_temp[1]);
        parser_result.max =
            double.tryParse(parser_temp[2]) / double.tryParse(parser_temp[3]);
      }
    }
    return parser_result;
  }
}

class ImagePostRequestResponse {
  String token;
  String imageLink;
}
