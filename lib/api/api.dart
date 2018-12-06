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

  AuthServer authServer;

  AkaliApi();

  @override
  Future prepare() async {
    databaseUri = options.context['databaseUri'];
    _db = AkaliMongoDatabase(databaseUri, logger);
    await _db.init();

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
        .link(() => ImgRequestHandler(_db, fileManager, logger));

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

  ImgRequestHandler(this.db, this.fileManager, this.logger);

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
        'message': 'PLEASE REPORT THIS INCIDENT TO WEBSITE ADMIN!',
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
      return Response.badRequest(body: {'error': 'Bad id number'});
    }
    var result = await db.queryImgID(_id);
    return Response.ok(result)..contentType = ContentType.json;
  }

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

  @Operation.put('id')
  Future<Response> putImage(
    @Bind.path('id') String id,
    @Bind.body() Pic newInfo, [
    @Bind.query('access_token') String token,
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

/*
  Future<MediaMessage> getImageFile(String id) async {
    // TODO: add file manager for remote file redirections if needed
    var file = File('$fileStoragePath/img/$id.png');
    if (!await file.exists()) {
      throw BadRequestError('Image with id=$id does not exist!');
    }
    var msg = MediaMessage()..bytes = file.readAsBytesSync();
    return msg;
  }

  Future<VoidMessage> postImageData(String token, Pic pic) async {
    await db.postImageData(pic);
    return VoidMessage();
  }

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
  */
}

class ImagePostRequestResponse {
  String token;
  String imageLink;
}
