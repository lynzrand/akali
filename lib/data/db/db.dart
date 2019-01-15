import 'dart:async';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:akali/config.dart';
import 'package:akali/data/pic.dart';
import 'package:akali/data/auth/auth.dart';

import 'package:aqueduct/aqueduct.dart';
import 'package:ulid/ulid.dart';

// TODO: Use Ulid instead of ObjectId for more universality
abstract class AkaliDatabase {
  static String databaseType;

  // ---- Query Stuff ----

  /// Initialization of the database. Override this function to provide
  /// your own initialization function.
  FutureOr<void> init();

  /// Search for a list of images satisfying [crit], limited to [limit] number
  /// and skips the first [skip] items.
  FutureOr<List<Pic>> queryImg(ImageSearchCriteria crit, {int limit, int skip});

  /// Get the specific picture with [id]
  FutureOr<Pic> queryImgID(ObjectId id);

  /// Update the information of image [id] with [newInfo]
  FutureOr<dynamic> updateImgInfo(Pic newInfo, ObjectId id);

  // ---- Auth stuff ----

  FutureOr<bool> checkToken(String accessToken, UserLevel level);

  FutureOr<void> grantedToken(String token, String tokenName,
      {Set<UserPrivilege> privileges, dynamic otherInfo});

  FutureOr<void> deletedToken(String token);

  FutureOr<AkaliUser> addUser(String username, String password,
      [Map<String, dynamic> otherInfo]);

  FutureOr<AkaliUser> changeUserInfo(int id, Map<String, dynamic> info);
}

// abstract class UlidOrObjectId implements Ulid, ObjectId {}
