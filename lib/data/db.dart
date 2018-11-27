import 'dart:async';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'pic.dart';
import 'package:akali/config.dart';

// TODO: Add abstract database class, so that one could add custom implementaion

/// Akali's default database implementation, using MongoDB
class AkaliDatabase {
  /// Connect to MongoDB at [uri].
  ///
  /// Remember to call [init] after creating a new [AkaliDatabase] instance.
  AkaliDatabase(this.uri) {
    assert(this.uri != null);
    // A simple check for valid mongodb address and fixes if it's not
    if (!uri.startsWith('mongodb://')) uri = 'mongodb://' + uri;
  }

  /// Initialize database connection.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    int tryTimes = 0;
    const maxTryTimes = 5;

    while (tryTimes < maxTryTimes) {
      print('[AkaliDB] Connecting to $uri');
      db = new Db(uri);
      try {
        await db.open();
        break;
      } catch (e) {
        print('[AkaliDB] Unable to connect database. Error: $e');
        print('[AkaliDB] Retrying after 1 second.');
        await Future.delayed(Duration(seconds: 1));
        tryTimes++;
      }
    }
    if (tryTimes >= maxTryTimes) {
      print('[AkaliDB] Unable to connect database. Giving up...');
      exit(25);
    }
    print('[AkaliDB] Connected to $uri');

    // Initialize collections
    picCollection = db.collection('pic');
    pendingPicCollection = db.collection('pendingPic');
    userCollection = db.collection('user');
  }

  bool _initialized = false;

  Db db;
  String uri;
  Configuration config;

  DbCollection picCollection;
  DbCollection pendingPicCollection;
  DbCollection userCollection;

  /// Post a new image to database. Returns the written confirmation.
  Future<void> postImageData(Pic pic) async {
    var map = await picCollection.insert(pic.toMap());
    return map;
  }

  /// Search for image(s) meeting the criteria [crit].
  Future<List<Pic>> searchForImage(ImageSearchCriteria crit) async {
    return (await picCollection.find({"tags": crit.tags}).toList()).map(
      (item) => Pic.fromMap(item),
    );
  }

  /// Find **the** picture with this [id].
  ///
  /// Preferably used when viewing specific pictures.
  Future<Pic> getImageById(ObjectId id) async {
    return Pic.fromMap(await picCollection.findOne(where.id(id)));
  }

  /// Adds an image with link [blobLink] and no info related
  /// to [pendingImageCollection]
  Future<String> addPendingImage(String blobLink) async {
    ObjectId id = ObjectId();
    await pendingPicCollection.insert({
      "_id": id,
      "link": blobLink + '/' + id.toHexString() + '.png',
    });
    return id.toHexString();
  }

  Future addInfoToPendingImage(Pic info) {}
}

class ImageSearchCriteria {
  List<String> tags;
}
