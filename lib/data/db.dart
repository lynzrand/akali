import 'dart:async';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:akali/config.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:ulid/ulid.dart';

import 'pic.dart';

// TODO: Use Ulid instead of ObjectId for more universality
abstract class AkaliDatabase {
  static String databaseType;

  /// Initialization of the database. Override this function to provide
  /// your own initialization function.
  FutureOr<void> init();

  /// Search for a list of images satisfying [crit].
  FutureOr<List<Pic>> queryImg(ImageSearchCriteria crit);

  /// Get the specific picture with [id]
  FutureOr<Pic> queryImgID(ObjectId id);

  /// Update the information of image [id] with [newInfo]
  FutureOr<dynamic> updateImgInfo(Pic newInfo, ObjectId id);
}

// abstract class UlidOrObjectId implements Ulid, ObjectId {}
