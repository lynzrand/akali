import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';
import 'package:aqueduct/src/auth/auth.dart';
import 'package:ulid/ulid.dart';
import 'package:crypto/crypto.dart';
import 'package:mongo_dart/mongo_dart.dart';

enum UserLevel {
  Guest,
  User,
  Manager,
  Admin,
}

// TODO: switch to a more flexible AuthScope implementation
// Do we need more detailed privileges? -- YES!

/// A list of what actions could the user do, in an abstract class.
///
/// This is a workaround form as valued enums are not present in Dart.
abstract class UserPrivilege {
  // Using SCREAMING_CAPS because this is an enum! =w=

  // === Guest level ===
  /// The ability to view public content on the site.
  /// Too bad if one cannot view any of the content in this website.
  static const VIEW_CONTENT = 0;

  // === User level ===
  /// The ability to modify (including creating) contents posted
  /// by the user himself
  static const EDIT_OWN_CONTENT = 1;

  /// The ability to tag other users' contents
  static const TAG_PUBLIC_CONTENT = 2;

  /// The ability to delete contents posted by the user himself
  static const DELETE_OWN_CONTENT = 3;

  /// The ablility to post a comment
  static const POST_COMMENT = 11;

  /// The ablility to change the profile of the user himself
  static const CHANGE_OWN_PROFILE = 21;

  // === Moderator level ===
  /// The ability to manage contents across the site
  static const EDIT_SITE_CONTENT = 100;

  /// The ability to delete contents across the site
  static const DELETE_SITE_CONTENT = 101;

  /// The ability to delete comments across the site
  static const DELETE_SITE_COMMENT = 111;

  /// The ability to change users' profile
  static const EDIT_USER_PROFILE = 120;

  /// The ability to change users' privileges (to at most this user's level);
  ///
  /// This also means that this moderator could disable other users' privileges
  /// privilege in order to ban users.
  static const EDIT_USER_PRIVILEGE = 121;

  /// The ability to approve other users' content
  /// (if the site is configured to force approvement before showing contents)
  static const APPROVE_CONTENT = 140;

  /// The ability to access the statistic data of the site.
  static const ACCESS_SITE_STATISTICS = 200;

  // === Admin Level ===
  /// The ability to have full control of the site;
  /// Should ONLY be given to the site admin(s)
  static const FULL_CONTROL = 451;
}

class AkaliUser extends ManagedObject implements ResourceOwner {
  /// How many time would you like the user to wait before validating?
  static const _passwordCheckWaitTime = Duration(milliseconds: 200);

  /// Unique User identifier
  // Wait... MongoDB uses a 96-bit integer as ObjectID, and the
  // ultimate implementation of Akali needs to use a 128-bit integer as ID.
  // TODO: make these things compatible with a 64-bit id  -- Rynco
  int get id;

  Ulid _id;

  /// Username, should be unique across platform
  String username;

  /// Password hash that should be stored into database.
  ///
  /// At ANY time this value should not be exposed
  // "String is okay. But I thought a buffer *could* be better."  -- Rynco
  String _hashedPassword;

  /// The salt value used to calculate the password
  String _salt;

  UserLevel userLevel;

  List<AuthScope> previleges;

  AkaliUser() {}

  AkaliUser.fromMap(final Map<String, dynamic> map) {}

  @override
  Map<String, dynamic> asMap([toDatabase = false]) {
    var map = super.asMap();
    if (toDatabase) {
      map['_salt'] = _salt;
      map['_hashedPassword'] = _hashedPassword;
    }
    return map;
  }

  /// Generates a new salt and hashes the [password] with salt
  void setPassword(String password) {
    // Replaced with existing HashedPassword generation function
    // provided by Aqueduct.
    //    Maximum code reusing! Yay! >_<
    _salt = AuthUtility.generateRandomSalt();

    // Add salt to password and hash it
    _hashedPassword = AuthUtility.generatePasswordHash(password, _salt);
  }

  /// Checks if [passwordToCheck] matches. Takes 500ms before returning, so
  /// we need to use async methods.
  Future<bool> checkPassword(String passwordToCheck) async {
    var bufToCheck = utf8.encode(passwordToCheck + _salt);
    var hashedBuf = sha256.convert(bufToCheck).bytes;
    var validation = false;
    await Future.wait([
      // try to avoid timing attack. We assume that any comparison between
      // fixed-sized int lists wouldn't exceed 200ms.
      // TODO: Use other validation methods like XORing buffers.
      Future.delayed(_passwordCheckWaitTime),
      Future(() => validation = hashedBuf == _hashedPassword),
    ]);
    return validation;
  }
}

/// A more versatile auth token that also serializes to a MongoDB entry
class SeriManagedToken extends ManagedAuthToken {
  SeriManagedToken() : super();
  SeriManagedToken.fromToken(AuthToken token) : super.fromToken(token);
  SeriManagedToken.fromCode(AuthCode code) : super.fromCode(code);

  /// Serializes this token into a MongoDB entry
  Map<String, dynamic> toMongoDBEntry() {
    return {
      "id": id,
      "code": code,
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "scope": scope.split(' '),
      "issueDate": issueDate,
      "expirationDate": expirationDate,
      "resourceOwner": resourceOwner.id,
      "client": client.id,
      "type": type,
    };
  }

  SeriManagedToken.readFromMap(Map<String, dynamic> keyValues) {
    keyValues['scope'] = (keyValues['scope'] as List).join(' ');
    super.readFromMap(keyValues);
  }
}

class SeriAuthClient extends ManagedAuthClient {}
