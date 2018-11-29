import 'dart:async';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:akali/config.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:ulid/ulid.dart';

import 'pic.dart';
import 'db.dart';

class AkaliPostgreSqlDb implements AkaliDatabase {
  @override
  FutureOr<void> init() {
    // TODO: implement init
    return null;
  }

  @override
  FutureOr<List<Pic>> queryImg(ImageSearchCriteria crit) {
    // TODO: implement queryImg
    return null;
  }

  @override
  FutureOr<Pic> queryImgID(ObjectId id) {
    // TODO: implement queryImgID
    return null;
  }

  @override
  FutureOr updateImgInfo(Pic newInfo, ObjectId id) {
    // TODO: implement updateImgInfo
    return null;
  }
}
