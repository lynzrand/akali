// A custom OAuth 2.0 implementation
import 'dart:async';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';

import 'package:akali/models.dart';
import 'package:akali/data/auth/auth.dart';
export 'package:akali/data/auth/auth.dart';

// TODO:
// Dig into the OAuth 2 implementation of Aqueduct and write a custom
// implementation reusing as many parts as possible. The original implementation
// uses PostgreSQL, so we cannot directly use it as we also need compatibility
// with MongoDB.
//
// And this thing is complex like HELL.
//
// Long way to go for Akali. *sigh*

/// The authorization delegate specifically for Akali use.
class AkaliAuthDelegate extends AuthServerDelegate {
  /// Creates a new [AkaliAuthDelegate] instance to be used.
  ///
  /// Unlike the vanilla [ManagedAuthDelegate], this one does not care what
  /// database you pass in as long as it implements [AkaliDatabase].
  AkaliAuthDelegate({this.db});

  AkaliDatabase db;

  FutureOr<AkaliUser> getResourceOwner(
      AuthServer server, String username) async {
    // Well, I think this does the work _(:> ∠)_
    return await db.getUser(username);
  }

  FutureOr<void> addClient(AuthServer server, AuthClient client) async {
    await db.addClient(client);
  }

  FutureOr<AuthClient> getClient(AuthServer server, String clientID) async {
    return await db.getClient(clientID);
  }

  FutureOr<void> removeClient(AuthServer server, String clientID) async {
    await db.removeClient(clientID);
  }

  FutureOr<AuthToken> getToken(AuthServer server,
      {String byAccessToken, String byRefreshToken}) async {
    if (byAccessToken != null && byRefreshToken == null) {
      return await db.getTokenByAccessToken(byAccessToken);
    } else if (byAccessToken == null && byRefreshToken != null) {
      return await db.getTokenByRefreshToken(byRefreshToken);
    } else {
      throw ArgumentError(
          "Only one of byAccessToken and byRefreshToken should not be null.");
    }
  }

  FutureOr removeToken(AuthServer server, AuthCode grantedByCode) async {
    await db.removeTokenByCode(grantedByCode);
  }

  FutureOr<void> removeTokens(AuthServer server, int resourceOwnerID) async {
    await db.removeAllTokens(resourceOwnerID);
  }

  FutureOr<void> addToken(AuthServer server, AuthToken token,
      {AuthCode issuedFrom}) async {
    await db.addToken(token, issuedFrom: issuedFrom);
  }

  FutureOr updateToken(
      AuthServer server,
      String oldAccessToken,
      String newAccessToken,
      DateTime newIssueDate,
      DateTime newExpirationDate) async {
    await db.updateToken(
        oldAccessToken, newAccessToken, newIssueDate, newExpirationDate);
  }

  FutureOr addCode(AuthServer server, AuthCode code) async {
    await db.addCode(code);
  }

  FutureOr<AuthCode> getCode(AuthServer server, String code) async {
    return await db.getCode(code);
  }

  FutureOr<void> removeCode(AuthServer server, String code) async {
    await db.removeCode(code);
  }

  List<AuthScope> getAllowedScopes(ResourceOwner owner) {
    if (ResourceOwner is! AkaliUser) {
      throw ArgumentError.value(owner);
    }
    return (owner as AkaliUser).previleges;
  }
}
