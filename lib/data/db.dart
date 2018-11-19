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
  AkaliDatabase(this.uri) {}

  /// Initialize database connection.
  Future<void> init() async {
    db = new Db(uri);
    await db.open();
    picCollection = db.collection(config.pictureCollectionName);
  }

  Db db;
  String uri;
  Configuration config;

  DbCollection picCollection;
  DbCollection userCollection;

  /// Post a new image to database
  void postImage(Pic pic) async {
    await picCollection.insert(pic.toMap());
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
}

class ImageSearchCriteria {
  List<String> tags;
  ImageRating rating;
}
