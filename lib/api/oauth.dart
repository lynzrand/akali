// A custom OAuth 2.0 implementation
import 'dart:async';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:aqueduct/aqueduct.dart';

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

  @override
  FutureOr removeToken(AuthServer server, AuthCode grantedByCode) {
    // TODO: implement removeToken
  }
}
