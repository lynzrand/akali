import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';

import 'package:akali/data/db/gridfs.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:akali/models.dart';
import 'package:akali/data/db/mongodb.dart';
import 'package:akali/data/auth/auth.dart';

import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';

import 'fs.dart';
import 'imgRequest.dart';
import 'oauth.dart';
import 'package:akali/logger/logger.dart';

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
    isolateName = Random().nextInt(9999);

    if (options.context['verbosity'] != null &&
        options.context['verbosity'] is Level) {
      logger.onRecord.listen(logHandlerFactory(options.context['verbosity']));
    }
    logger.info("Starting Akali $isolateName");

    databaseUri = options.context['databaseUri'];

    // protocol parse
    String protocol;
    RegExp regProtocol = new RegExp(r"^(.+)://");
    Match matchProtocol = regProtocol.firstMatch(databaseUri);
    if (matchProtocol != null) {
      protocol = matchProtocol.group(1);
    } else {
      throw ArgumentError.value(
          databaseUri, "databaseUri", "No protocol specified in uri");
    }

    switch (protocol) {
      case "mongodb":
        _db = AkaliMongoDatabase(databaseUri);
        break;
      default:
        throw ArgumentError.value(
            databaseUri, "databaseUri", "Unable to determine protocol");
    }
    await _db.init();

    fileStoragePath = options.context['fileStoragePath'];
    webRootPath = options.context['webRootPath'];
    // fileManager = AkaliLocalFileManager(fileStoragePath, webRootPath);
    fileManager = AkaliGridFS(databaseUri);

    final authDelegate = AkaliAuthDelegate(db: _db);
    authServer = AuthServer(authDelegate);

    logger.info(
        "Akali $isolateName listening on ${options.address}:${options.port}");
  }

  @override
  Controller get entryPoint {
    final router = Router(basePath: '/api/v1');

    router.route('/ping').linkFunction(
        (req) => Response.ok('HTTP 200. The server is all right!'));

    router
        .route('/img/[:id]')
        .link(() => ImgRequestHandler(_db, fileManager, webRootPath));

    router.route('/file/*').link(() => FileController(fileStoragePath));

    router.route('/auth/token').link(() => AuthController(authServer));
    router.route('/auth/code').link(() => AuthRedirectController(authServer));
    router.route('/auth/register').link(() => AkaliRegisterController(_db));

    return router;
  }

  Request handle(Request req) {
    logger.fine(req);
    return req;
  }
}
