import 'dart:async';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:postgres/postgres.dart';
import 'package:aqueduct/aqueduct.dart';

import 'package:akali/models.dart';
import 'package:akali/data/auth/auth.dart';

/// The PostgreSQL implementation of [AkaliDatabase]. Mostly undone.
class AkaliPostgreSqlDb implements AkaliDatabase {
  bool _initialized = false;

  Logger logger;
  String host;
  int port;
  String databaseName;
  String username;
  String password;

  PostgreSQLConnection dbConn;

  static String databaseType = "PostgresqlDB";
  static String _dbPrefix = "[$databaseType]";

  AkaliPostgreSqlDb(String uri, Logger logger) {
    this.logger = logger;
  }

  @override
  FutureOr<void> init() async {
    if (_initialized) return;
    _initialized = true;

    int tryTimes = 0;
    const maxTryTimes = 5;

    while (tryTimes < maxTryTimes) {
      logger.info("$_dbPrefix Connecting to $databaseName");
      dbConn = new PostgreSQLConnection(host, port, databaseName,
          username: username, password: password);
      try {
        await dbConn.open();
        break;
      } catch (e, stacktrace) {
        logger.warning(
            "$_dbPrefix Unable to connect with $databaseName", e, stacktrace);
        await Future.delayed(Duration(seconds: 1));
        tryTimes++;
      }
    }
    if (tryTimes >= maxTryTimes) {
      logger.severe("$_dbPrefix Unable to connect $databaseName. Giving up.");
      exit(25);
    }
    logger.info("$_dbPrefix Connected to $databaseName.");

    // Initialize collections
  }

  @override
  FutureOr<List<Pic>> queryImg(
    ImageSearchCriteria crit, {
    int limit,
    int skip,
  }) {
    // TODO: implement queryImg
    return null;
  }

  @override
  FutureOr<Pic> queryImgID(String id) {
    // TODO: implement queryImgID
    return null;
  }

  @override
  FutureOr updateImgInfo(Pic newInfo, String id) {
    // TODO: implement updateImgInfo
    return null;
  }

  @override
  Future<void> deleteImg(String id) {}

  // =============

  FutureOr<void> addToken(AuthToken token, {AuthCode issuedFrom}) {
    // TODO: implement grantedToken
    return null;
  }

  FutureOr<void> removeToken(String token) {
    // TODO: implement deletedToken
    return null;
  }

  FutureOr<AkaliUser> addUser(AkaliUser user) {
    // TODO: implement addUser
    return null;
  }

  FutureOr<bool> checkToken(String accessToken, Set<int> privileges) {
    // TODO: implement checkToken
    return null;
  }

  FutureOr<AkaliUser> changeUserInfo(int id, Map<String, dynamic> info) {
    // TODO: implement changeUserInfo
    return null;
  }

  @override
  FutureOr<AuthClient> addClient(AuthClient client) {
    // TODO: implement addClient
    return null;
  }

  @override
  FutureOr<void> addCode(AuthCode code) {
    // TODO: implement addCode
    return null;
  }

  @override
  FutureOr deleteUser(String username) {
    // TODO: implement deleteUser
    return null;
  }

  @override
  FutureOr deleteUserById(String id) {
    // TODO: implement deleteUserById
    return null;
  }

  @override
  FutureOr<AuthClient> getClient(String clientID) {
    // TODO: implement getClient
    return null;
  }

  @override
  FutureOr<AuthCode> getCode(String code) {
    // TODO: implement getCode
    return null;
  }

  @override
  FutureOr<AuthToken> getTokenByAccessToken(String accessToken) {
    // TODO: implement getTokenByAccessToken
    return null;
  }

  @override
  FutureOr<AuthToken> getTokenByRefreshToken(String refreshToken) {
    // TODO: implement getTokenByRefreshToken
    return null;
  }

  @override
  FutureOr<AkaliUser> getUser(String username) {
    // TODO: implement getUser
    return null;
  }

  @override
  FutureOr<AkaliUser> getUserById(String id) {
    // TODO: implement getUserById
    return null;
  }

  @override
  FutureOr<void> removeAllTokens(int resourceOwnerID) {
    // TODO: implement removeAllTokens
    return null;
  }

  @override
  FutureOr removeClient(String clientID) {
    // TODO: implement removeClient
    return null;
  }

  @override
  FutureOr removeCode(String code) {
    // TODO: implement removeCode
    return null;
  }

  @override
  FutureOr<void> removeTokenByCode(AuthCode code) {
    // TODO: implement removeTokenByCode
    return null;
  }

  @override
  FutureOr<void> updateToken(String oldToken, String newToken,
      DateTime newIssueDate, DateTime newExpirationDate) {
    // TODO: implement updateToken
    return null;
  }

  @override
  FutureOr createImg(Pic img) {
    // TODO: implement createImg
    return null;
  }

  @override
  FutureOr createImgId(ObjectId id) {
    // TODO: implement createImgId
    return null;
  }
}
