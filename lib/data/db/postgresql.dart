import 'dart:async';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:ulid/ulid.dart';

import 'package:akali/config.dart';
import 'package:akali/models.dart';
import 'package:akali/data/auth/auth.dart';

/// The PostgreSQL implementation of [AkaliDatabase]. Mostly undone.
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

  FutureOr<void> addToken(AuthToken token, {AuthCode issuedFrom}) {
    // TODO: implement grantedToken
    return null;
  }

  FutureOr<void> removeToken(String token) {
    // TODO: implement deletedToken
    return null;
  }

  FutureOr<AkaliUser> addUser(AkaliUser user) {
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

  @override
  FutureOr<AuthClient> addClient(AuthClient client) {
    // TODO: implement addClient
    return null;
  }

  @override
  FutureOr<void> addCode(AuthCode code) {
    // TODO: implement addCode
    return null;
  }

  @override
  FutureOr deleteUser(String username) {
    // TODO: implement deleteUser
    return null;
  }

  @override
  FutureOr deleteUserById(ObjectId id) {
    // TODO: implement deleteUserById
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

  @override
  FutureOr<AuthToken> getTokenByAccessToken(String accessToken) {
    // TODO: implement getTokenByAccessToken
    return null;
  }

  @override
  FutureOr<AuthToken> getTokenByRefreshToken(String refreshToken) {
    // TODO: implement getTokenByRefreshToken
    return null;
  }

  @override
  FutureOr<AkaliUser> getUser(String username) {
    // TODO: implement getUser
    return null;
  }

  @override
  FutureOr<AkaliUser> getUserById(ObjectId id) {
    // TODO: implement getUserById
    return null;
  }

  @override
  FutureOr<void> removeAllTokens(int resourceOwnerID) {
    // TODO: implement removeAllTokens
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
