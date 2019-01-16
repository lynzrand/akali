import 'dart:async';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:ulid/ulid.dart';

import 'package:akali/config.dart';
import 'package:akali/models.dart';
import 'package:akali/data/auth/auth.dart';

class AkaliPostgreSqlDb implements AkaliDatabase {
  @override
  FutureOr<void> init() {
    // TODO: implement init
    return null;
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
  FutureOr<Pic> queryImgID(ObjectId id) {
    // TODO: implement queryImgID
    return null;
  }

  @override
  FutureOr updateImgInfo(Pic newInfo, ObjectId id) {
    // TODO: implement updateImgInfo
    return null;
  }

  // =============

  FutureOr<void> grantedToken(UserToken token) {
    // TODO: implement grantedToken
    return null;
  }

  FutureOr<void> deletedToken(String token) {
    // TODO: implement deletedToken
    return null;
  }

  FutureOr<AkaliUser> addUser(String username, String password,
      [Map<String, dynamic> otherInfo]) {
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
}
