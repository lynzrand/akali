import 'dart:async';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:ulid/ulid.dart';

import 'package:akali/config.dart';
import 'package:akali/models.dart';

/// Akali's default database implementation, using MongoDB
class AkaliMongoDatabase implements AkaliDatabase {
  bool _initialized = false;

  Logger logger;

  Db db;
  String uri;
  // Configuration config;

  DbCollection picCollection;
  DbCollection pendingPicCollection;
  DbCollection userCollection;

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
    picCollection = db.collection('pic');
    pendingPicCollection = db.collection('pendingPic');
    userCollection = db.collection('user');
  }

  /// Post a new image to database. Returns the written confirmation.
  Future<void> postImageData(Pic pic) async {
    var map = await picCollection.insert(pic.asMap());
    return map;
  }

  /// Search for image(s) meeting the criteria [crit].
  Future<List<Pic>> queryImg(ImageSearchCriteria crit) async {
    return (await picCollection.find({'tags': crit.tags}).toList()).map(
      (item) => Pic.readFromMap(item),
    );
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

  Future addInfoToPendingImage(Pic info) {}
}
