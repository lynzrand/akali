import 'package:mongo_dart/mongo_dart.dart';
import 'pic.dart';
import '../config.dart';

class AkaliDatabase {
  AkaliDatabase(this.uri) {}

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

  Future<List<Pic>> searchForImage(ImageSearchCriteria crit) async {}

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
