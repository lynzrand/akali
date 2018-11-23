import 'dart:async';

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
    // A simple check for valid mongodb address and fixes if it's not
    if (!uri.startsWith('mongodb://')) uri = 'mongodb://' + uri;
    init();
  }

  /// Initialize database connection.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    print('[AkaliDB] Connecting to $uri');
    db = new Db(uri);
    try {
      await db.open();
    } catch (e) {
      print(e);
      throw e;
    }
    print('[AkaliDB] Connected to $uri');
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
      "link": blobLink,
    });
    return id.toHexString();
  }

  Future addInfoToPendingImage(Pic info) {}
}

class ImageSearchCriteria {
  List<String> tags;
}
