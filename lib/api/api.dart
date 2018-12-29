import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:akali/data/db.dart';
import 'package:akali/data/pic.dart';
import 'package:akali/data/mongodb.dart';

import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';

import 'fs.dart';

/// Akali's default API.
class AkaliApi extends ApplicationChannel {
  ManagedContext context;

  int port;
  int isolateName;

  String databaseUri;
  AkaliDatabase _db;

  String rootPath;
  AkaliFileManager fileManager;

  bool useLocalFileStorage;
  String fileStoragePath;
  String webRootPath;

  AuthServer authServer;

  AkaliApi();

  @override
  Future prepare() async {
    databaseUri = options.context['databaseUri'];
    _db = AkaliMongoDatabase(databaseUri, logger);
    await _db.init();

    fileStoragePath = options.context['fileStoragePath'];
    webRootPath = options.context['webRootPath'];
    fileManager = AkaliLocalFileManager(fileStoragePath, webRootPath);

    final authDelegate = ManagedAuthDelegate(context);
    authServer = AuthServer(authDelegate);

    // logger.onRecord.listen(_handleLog);

    logger.info("Akali listening on ${options.address}:${options.port}");
  }

  void _handleLog(LogRecord rec) {
    print(rec);
  }

  @override
  Controller get entryPoint {
    final router = Router(basePath: '/api/v1');

    router
        .route('/img/[:id]')
        .link(() => ImgRequestHandler(_db, fileManager, logger, webRootPath));

    router.route('/auth').link(() => AuthController(authServer));

    return router;
  }

  Request handle(Request req) {
    logger.fine(req);
    return req;
  }
}

class ImgRequestHandler extends ResourceController {
  AkaliDatabase db;
  AkaliFileManager fileManager;
  Logger logger;

  String webRootPath;

  ImgRequestHandler(this.db, this.fileManager, this.logger, this.webRootPath);

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
  // @ApiMethod(name: 'Search image by query', method: 'GET', path: 'img')
  // Future<List<Pic>> getPicByQuery({
  // ## Current workaround: call custon toJson() and return a string, instead of
  // returning the object and let rpc do the job.
  @Operation.get()
  Future<Response> listPicByQuery({
    @Bind.query('tags') String tags,
    @Bind.query('author') String author,
    @Bind.query('size') String sizeCriteria,
    @Bind.query('height') String height,
    @Bind.query('width') String width,
    @Bind.query('ratio') String ratio,
    @Bind.query('limit') int limit = 20,
    @Bind.query('skip') int skip = 0,
  }) async {
    List<String> tagsList;
    List<String> authorList;
    CriteriaTween heightRange;
    CriteriaTween widthRange;
    CriteriaTween ratioRange;
    // double minAspectRatio;
    // double maxAspectRatio;
    try {
      // Please note that seen by the server, query 'xxx+yyy' is the same as 'xxx yyy'.
      tagsList = _queryStringParser(tags);
      authorList = _queryStringParser(author);
      heightRange = _queryRangeParser(height);
      widthRange = _queryRangeParser(width);
      ratioRange = _queryRatioRangeParser(ratio);
      // TODO: Add size search
      // if (minAspectRatioStr != null)
      //   minAspectRatio = double.tryParse(minAspectRatioStr);
      // if (maxAspectRatioStr != null)
      //   maxAspectRatio = double.tryParse(maxAspectRatioStr);
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
      
    try {
      var searchResults = await db.queryImg(searchQuery);
      return Response.ok(searchResults)..contentType = ContentType.json;
    } catch (e, stack) {
      print(e);
      print(stack);
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
    var _id;
    try {
      _id = ObjectId.fromHexString(id);
    } catch (e) {
      throw Response.badRequest(body: {'error': 'Bad id number'});
    }
    var result = await db.queryImgID(_id);
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
    var id = ObjectId();
    var path;
    try {
      path = await fileManager.streamImageFileFrom(upload.body.bytes,
          id.toHexString() + '.' + upload.raw.headers.contentType.subType);
      // return Response.created(path.path);
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      throw Response.serverError(body: {
        "error": e,
        "message": "Please report this to the developers",
        'stacktrace': stackTrace,
      });
    }
    return Response.ok({"success": true, "dir": webRootPath + path});
  }

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
    // TODO: authorization
    var _id = ObjectId.fromHexString(id);
    var result;
    try {
      result = await db.updateImgInfo(newInfo, _id);
    } catch (e) {
      return Response.badRequest(body: {'error': e, 'message': result});
    }
    return Response.ok(result);
  }

  /// DELETE `/img/:id`
  ///
  /// Deletes the coresponding image and its metadata
  @Operation.delete('id')
  Future<Response> deleteImageId(@Bind.path('id') String id) {}

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
