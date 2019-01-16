import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';
import 'package:ulid/ulid.dart';
import 'package:crypto/crypto.dart';
import 'package:mongo_dart/mongo_dart.dart';

enum UserLevel {
  Guest,
  User,
  Manager,
  Admin,
}

/// A list of what actions could the user do, in an abstract class.
///
/// This is a workaround form as valued enums are not present in Dart.
abstract class UserPrivilege {
  // TODO: do we need more detailed privileges?
  // TODO: When Dart FINALLY accepts valued enums, we need to rewrite this.

  /* === CAUTION ===
   * The values in this fake enum should not be changed once determined
   * to preserve backward compatibility. If we DO need to change this,
   * mark as a breaking update.
   */

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
  static const FULL_CONTROL = 300;
}

class AkaliUser extends ManagedObject {
  /// How much salt would you add on your hash?
  static const _hashSaltLength = 64;

  /// How many time would you like the user to wait before validating?
  static const _passwordCheckWaitTime = Duration(milliseconds: 200);

  /// User identifier
  Ulid id;

  /// Username, should be unique across platform
  String username;

  /// Password hash that should be stored into database.
  ///
  /// At ANY time this value should not be exposed
  List<int> _hashedPassword;

  /// Gets the BSON Binary form of the hashed password. Goes to MondoDB entry.
  BsonBinary get binaryHashedPassword {
    return BsonBinary.from(_hashedPassword);
  }

  /// The salt value used to calculate the password
  String _salt;

  UserLevel userLevel;

  Set<int> previleges;

  AkaliUser() {}

  AkaliUser.fromMap(Map<String, dynamic> map) {}

  /// Generates a new salt and hashes the [password] with salt
  void setPassword(String password) {
    var randomizer = Random.secure();
    // Generate salt from a list of secure random integers
    _salt = String.fromCharCodes(
      List.generate(_hashSaltLength, (_) => randomizer.nextInt(95) + 32),
    );
    // Add salt to password and hash it
    var buf = utf8.encode(password + _salt);
    _hashedPassword = sha256.convert(buf).bytes;
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

/// A token for user authorization.
class UserToken extends ManagedObject {
  int userId;
  String token;
  String name;
  Map<String, dynamic> otherInfo;
  DateTime expires;

  UserToken(
    this.token,
    this.name, {
    this.otherInfo,
    this.expires,
  });
}

/// A token for authorized 3rd party software to access user information
class UserAccessToken extends UserToken {
  Set<int> privileges;

  UserAccessToken(
    token,
    name, {
    this.privileges,
    otherInfo,
    expires,
  }) : super(token, name, otherInfo: otherInfo, expires: expires);
}
