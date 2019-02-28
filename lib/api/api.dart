import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:akali/models.dart';
import 'package:akali/data/db/mongodb.dart';
import 'package:akali/data/auth/auth.dart';

import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';

import 'fs.dart';
import 'imgRequest.dart';
import 'oauth.dart';

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

    // protocol parse
    String protocol;
    RegExp regProtocol = new RegExp(r"(\d+)://");
    Match matchProtocl = regProtocol.firstMatch(databaseUri);
    if (matchProtocl != null) {
      protocol = matchProtocl.group(1);
    } else {
      logger.info("bad database uri.");
      return;
    }

    switch (protocol) {
      case "mongodb":
        _db = AkaliMongoDatabase(databaseUri, logger);
        await _db.init();
        break;
      default:
        logger.info("not supported database protocol");
        return;
    }

    fileStoragePath = options.context['fileStoragePath'];
    webRootPath = options.context['webRootPath'];
    fileManager = AkaliLocalFileManager(fileStoragePath, webRootPath);

    final authDelegate = AkaliAuthDelegate(db: _db);
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

    router.route('/ping').linkFunction(
        (req) => Response.ok('HTTP 200. The server is all right!'));

    router
        .route('/img/[:id]')
        .link(() => ImgRequestHandler(_db, fileManager, logger, webRootPath));

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
