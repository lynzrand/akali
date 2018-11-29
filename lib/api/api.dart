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

/// Akali's default API.
class AkaliApi extends ApplicationChannel {
  ManagedContext context;

  int port;
  int isolateName;

  String databaseUri;
  AkaliDatabase _db;

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

    router.route('/img/[:id]').link(() => ImgRequestHandler(_db, logger));

    router.route('/auth/token').link(() => AuthController(authServer));

    return router;
  }

  Request handle(Request req) {
    logger.fine(req);
    return req;
  }
}

class AkaliAuthDelegate<T> {}

class ImgRequestHandler extends ResourceController {
  AkaliMongoDatabase db;
  Logger logger;

  ImgRequestHandler(this.db, this.logger);

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
    @Bind.query('pretty') bool pretty = false,
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
    Map<String, dynamic> searchQuery = {};

    // Search for specific tags
    if (tagsList?.isNotEmpty ?? false)
      searchQuery['tags'] = {'\$all': tagsList};

    if (authorList?.isNotEmpty ?? false)
      searchQuery['author'] = {'\$or': authorList};

    try {
      var searchResults = await db.picCollection
          .find(where.raw(searchQuery).limit(limit).skip(skip))
          .toList();
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

  @Operation.get('id')
  Future<Response> getImage(@Bind.path('id') String id) async {
    var _id;
    try {
      _id = ObjectId.fromHexString(id);
    } catch (e) {
      return Response.badRequest(body: {'error': 'Bad id number'});
    }
    var result = await db.picCollection.findOne(where.id(_id));
    return Response.ok(result)..contentType = ContentType.json;
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
      result = await db.picCollection.update(where.id(_id), newInfo);
    } catch (e) {
      return Response.badRequest(body: {'error': e, 'message': result});
    }
    return Response.ok(result);
  }

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
