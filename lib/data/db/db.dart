import 'dart:async';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:akali/config.dart';
import 'package:akali/data/models/pic.dart';
import 'package:akali/data/auth/auth.dart';

import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';
import 'package:ulid/ulid.dart';

/// Database for Akali.
///
/// Using `ObjectId` from MongoDB instead of a more common ID for now.
/// Sorry, PostgreSQL implementers.
///
/// Any implementation should implement ALL functions listed below
/// to make this database functioning. Bad things will happen if you don't.
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

  Future<void> deleteImg(ObjectId id);

  // ---- Auth stuff ----

  // /// Check if the [accessToken] required has [privileges].
  // FutureOr<bool> checkToken(String accessToken, Set<int> privileges);

  /// Add the [token]
  /// granted by a user data manager to the token database.
  FutureOr<void> addToken(AuthToken token, {AuthCode issuedFrom});

  FutureOr<AuthToken> getTokenByAccessToken(String accessToken);
  FutureOr<AuthToken> getTokenByRefreshToken(String refreshToken);

  /// Delete the [token] from database.
  FutureOr<void> removeToken(String token);
  FutureOr<void> removeTokenByCode(AuthCode code);
  FutureOr<void> updateToken(String oldToken, String newToken,
      DateTime newIssueDate, DateTime newExpirationDate);

  FutureOr<void> removeAllTokens(int resourceOwnerID);

  FutureOr<AuthClient> addClient(AuthClient client);
  FutureOr<AuthClient> getClient(String clientID);
  FutureOr removeClient(String clientID);

  FutureOr<void> addCode(AuthCode code);
  FutureOr<AuthCode> getCode(String code);
  FutureOr removeCode(String code);

  /// Add a new user having [username], [password] and [otherInfo]
  /// to existing user database.
  FutureOr<AkaliUser> addUser(AkaliUser user);

  /// Gets the information of user [username].
  FutureOr<AkaliUser> getUser(String username);

  /// Gets the information of user [id].
  FutureOr<AkaliUser> getUserById(ObjectId id);

  /// Deletes the specific user by [username].
  // Flagging them for deletion and delete after a period of time may be a
  // better idea? Not sure  -- Rynco
  FutureOr deleteUser(String username);

  /// Deletes the specific user by [id].
  FutureOr deleteUserById(ObjectId id);

  /// Modify user [id]'s info to match [info]
  FutureOr<AkaliUser> changeUserInfo(int id, Map<String, dynamic> info);
}

// abstract class UlidOrObjectId implements Ulid, ObjectId {}
