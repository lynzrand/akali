import 'dart:async';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';
import 'package:ulid/ulid.dart';

import 'package:akali/config.dart';
import 'package:akali/models.dart';
import 'package:akali/data/auth/auth.dart';

/// Akali's default database implementation, using MongoDB
class AkaliMongoDatabase implements AkaliDatabase {
  static const _picCollectionName = "pic";
  static const _pendingPicCollectionName = "pendingPic";
  static const _userDataCollectionName = "user";
  static const _tokenCollectionName = "token";
  static const _authCodeCollectionName = "authCode";
  static const _clientCollectionName = "client";

  bool _initialized = false;

  Logger logger;

  Db db;
  String uri;
  // Configuration config;

  DbCollection picCollection;
  DbCollection pendingPicCollection;
  DbCollection userCollection;
  DbCollection tokenCollection;
  DbCollection authCodeCollection;
  DbCollection clientCollection;

  static String databaseType = "MongoDB";
  static String _dbPrefix = "[$databaseType]";

  /// Connect to MongoDB at [uri].
  ///
  /// Remember to call [init] after creating a new [AkaliMongoDatabase] instance.
  AkaliMongoDatabase(this.uri, this.logger) {
    assert(this.uri != null);
    // A simple check for valid mongodb address and fixes if it's not
    if (!uri.startsWith('mongodb://')) uri = 'mongodb://' + uri;
  }

  /// Initialize database connection.
  @override
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    int tryTimes = 0;
    const maxTryTimes = 5;

    while (tryTimes < maxTryTimes) {
      logger.info("$_dbPrefix Connecting to $uri");
      db = new Db(uri);
      try {
        await db.open();
        break;
      } catch (e, stacktrace) {
        logger.warning("$_dbPrefix Unable to connect with $uri", e, stacktrace);
        await Future.delayed(Duration(seconds: 1));
        tryTimes++;
      }
    }
    if (tryTimes >= maxTryTimes) {
      logger.severe("$_dbPrefix Unable to connect $uri. Giving up.");
      exit(25);
    }
    logger.info("$_dbPrefix Connected to $uri.");

    // Initialize collections
    picCollection = db.collection(_picCollectionName);
    pendingPicCollection = db.collection(_pendingPicCollectionName);
    userCollection = db.collection(_userDataCollectionName);
    tokenCollection = db.collection(_tokenCollectionName);
    clientCollection = db.collection(_clientCollectionName);
    authCodeCollection = db.collection(_authCodeCollectionName);
  }

  /// Post a new image to database. Returns the written confirmation.
  Future<void> postImageData(Pic pic) async {
    var map = await picCollection.insert(pic.asMap());
    return map;
  }

  /// Search for image(s) meeting the criteria [crit].
  Future<List<Pic>> queryImg(
    ImageSearchCriteria crit, {
    int limit = 20,
    int skip = 0,
  }) async {
    var query = where;

    if (crit.tags != null) query = query.all('tags', crit.tags);
    if (crit.authors != null) query = query.all('author', crit.authors);
    if (crit.height != null) {
      if (crit.height.max != null)
        query = query.inRange('height', crit.height.min, crit.height.max,
            maxInclude: true);
      else
        query = query.all('height', [crit.height.min]);
    }
    if (crit.width != null) {
      if (crit.width.max != null)
        query = query.inRange('width', crit.width.min, crit.width.max,
            maxInclude: true);
      else
        query = query.all('height', [crit.width.min]);
    }

    query = query.limit(limit).skip(skip);

    return (await picCollection.find(query))
        .map((item) => Pic.readFromMap(item))
        .toList();
  }

  /// Find **the** picture with this [id].
  ///
  /// Preferably used when viewing specific pictures.
  Future<Pic> queryImgID(ObjectId id) async {
    return Pic.readFromMap(await picCollection.findOne(where.id(id)));
  }

  Future<dynamic> updateImgInfo(Pic newInfo, ObjectId id) async {
    return await picCollection.update(where.id(id), newInfo.asMap());
  }

  /// Adds an image with link [blobLink] and no info related
  /// to [pendingImageCollection]
  Future<String> addPendingImage(String blobLink) async {
    ObjectId id = ObjectId();
    await pendingPicCollection.insert({
      '_id': id,
      'link': blobLink + '/' + id.toHexString() + '.png',
    });
    return id.toHexString();
  }

  Future addInfoToPendingImage(Pic info) async {
    // TODO: implement addInfoToPendingImage
    return null;
  }

  // =============

  FutureOr<void> addToken(AuthToken token, {AuthCode issuedFrom}) async {
    final serializableToken = SeriManagedToken.fromToken(token);
    final map = serializableToken.toMongoDBEntry();
    if (issuedFrom != null) {
      map['issuedFrom'] = issuedFrom.code;
    }
    await tokenCollection.insert(map);
  }

  FutureOr<bool> checkToken(String accessToken) async {
    // TODO: implement checkToken
    return null;
  }

  FutureOr<void> removeToken(String token) async {
    await tokenCollection.remove(where.eq('accessToken', token));
  }

  FutureOr<void> removeAllTokens(int resourceOwnerID) async {
    await tokenCollection.remove(where.eq('resourceOwner', resourceOwnerID));
  }

  FutureOr<AkaliUser> addUser(AkaliUser user) async {
    await userCollection.insert(user.asMap());
    return null;
  }

  FutureOr<AkaliUser> getUser(String username) async {
    return AkaliUser.fromMap(
        await userCollection.findOne(where.eq("username", username)));
  }

  FutureOr<void> deleteUser(String username) async {
    await userCollection.remove(where.eq('username', username));
  }

  FutureOr<void> deleteUserById(ObjectId id) async {
    await userCollection.remove(where.id(id));
  }

  FutureOr<AkaliUser> changeUserInfo(int id, Map<String, dynamic> info) async {
    // TODO: implement changeUserInfo
    return null;
  }

  @override
  FutureOr<AuthClient> addClient(AuthClient client) async {
    return null;
  }

  @override
  FutureOr<void> addCode(AuthCode code) {
    // TODO: implement addCode
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

  // TODO: this thing definitely needs optimization
  FutureOr<AuthToken> getTokenByAccessToken(String accessToken) async {
    return SeriManagedToken.readFromMap(
            await tokenCollection.findOne(where.eq('accessToken', accessToken)))
        .asToken();
  }

  @override
  FutureOr<AuthToken> getTokenByRefreshToken(String refreshToken) async {
    return SeriManagedToken.readFromMap(await tokenCollection
            .findOne(where.eq('refreshToken', refreshToken)))
        .asToken();
  }

  @override
  FutureOr<AkaliUser> getUserById(ObjectId id) {
    // TODO: implement getUserById
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
}
