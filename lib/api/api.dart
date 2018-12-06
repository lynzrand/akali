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

class AkaliAuthDelegate<T> {}

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
      await _customHandleUploadImage(request);
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
    @Bind.query('limit') int limit = 20,
    @Bind.query('skip') int skip = 0,
  }) async {
    List<String> tagsList;
    List<String> authorList;
    // double minAspectRatio;
    // double maxAspectRatio;
    try {
      // Please note that seen by the server, query 'xxx+yyy' is the same as 'xxx yyy'.
      tagsList = tags?.split(' ');
      authorList = author?.split(' ');
      // TODO: Add size search
      // if (minAspectRatioStr != null)
      //   minAspectRatio = double.tryParse(minAspectRatioStr);
      // if (maxAspectRatioStr != null)
      //   maxAspectRatio = double.tryParse(maxAspectRatioStr);
    } catch (e, stacktrace) {
      throw Response.badRequest(body: {'error': e, 'stacktrace': stacktrace});
    }
    var searchQuery = ImageSearchCriteria();

    // Search for specific tags
    if (tagsList?.isNotEmpty ?? false) searchQuery.tags = tagsList;

    if (authorList?.isNotEmpty ?? false) searchQuery.authors = authorList;

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

  /// GET /img/[id]
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
/*
  /// POST /img
  ///
  /// POSTs a new file to Akali server. Returns whether this operation is
  /// successful, and the address to PUT/POST the image metadata to.
  @Operation.post()
  Future<Response> postNewImage(
    @Bind.body() List<int> file,
    @Bind.header('Content-Type') String fileType,
    Request req,
  ) async {
    var id = ObjectId();
    // The following code is only for DEBUG use
    print(fileType);

    // await fileManager.streamFileTo('img/${id.toHexString()}', file);
    return Response.ok(id.toHexString());
  }
*/

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
    return Response.created(webRootPath + path);
  }

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

  @Operation.delete('id')
  Future<Response> deleteImageId(@Bind.path('id') String id) {}
}

class ImagePostRequestResponse {
  String token;
  String imageLink;
}
