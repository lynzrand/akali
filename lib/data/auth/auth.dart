import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';
import 'package:aqueduct/src/auth/auth.dart';
import 'package:ulid/ulid.dart';
import 'package:uuid/uuid.dart';
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

  /// (Probably) the Unique User identifier. It's not the key in
  /// any databases, but _should_ be stored in case we need it.
  ///
  /// It's basically the last 64 bits of the ObjectID. With this much
  /// randomness we _hope_ it would not collide with others.
  ///
  // Wait... MongoDB uses a 96-bit integer as ObjectID, and the
  // ultimate implementation of Akali needs to use a 128-bit integer as ID.
  //
  // Alright screw that I'll use my own implementation
  int get id {
    return _id.id.byteArray.getInt64(1);
  }

  /// The identifier used by MongoDB
  ObjectId get objectId => _id;

  /// The inner user identifier. Databases other than MongoDB
  /// should use this value and pad 32 bits of zeros after it.
  ObjectId _id;

  /// The UUID of this user. Basically it's just the ObjectID reformed with
  /// some zeros. If your database does not store 96-bit integers, try storing
  /// this as it matches the 128-bit UUID format.
  ///
  /// The conversion works as shown to maintain a stable conversion:
  ///
  ///     ObjectId:
  ///     [ Timestamp: 4 bytes ] [ Machine: 3 bytes ]
  ///     [ PID: 2 bytes ] [ Random: 3 bytes ]
  ///
  ///     UUID (v1):
  ///     msecs: [ Timestamp ]          (32 bits, as miliseconds)
  ///     nsecs: [ PID ] >> 3           (13 bits)
  ///     clockseq: [ PID ] & 0xC       (3 bits)
  ///     node:  [ Machine ] [ Random ] (48 bits)
  ///
  /// And yes, you can still retrieve the time data from the UUID.
  String get uuid {
    final bytes = _id.id.byteArray;
    final msecs = _id.dateTime.millisecondsSinceEpoch;
    final nsecs = bytes.getUint16(7) / 8;
    final clockseq = bytes.getUint8(8) % 8;
    final node = [
      bytes.getUint8(4),
      bytes.getUint8(5),
      bytes.getUint8(6),
      bytes.getUint8(9),
      bytes.getUint8(10),
      bytes.getUint8(11)
    ];

    return Uuid().v1(options: {
      "msecs": msecs,
      "nsecs": nsecs,
      "clockseq": clockseq,
      "node": node
    });
  }

  /// Username, should be unique across platform
  String username;

  /// Password hash that should be stored into database.
  ///
  /// At ANY time this value should not be exposed
  // String is okay. But I thought a buffer *could* be better.  -- Rynco
  String hashedPassword;

  /// Salt used to calculate hash
  String salt;

  List<AuthScope> privileges;

  AkaliUser() : super();

  AkaliUser.fromMap(final Map<String, dynamic> map) {}

  @override
  Map<String, dynamic> asMap([toDatabase = false]) {
    var map = super.asMap();
    if (toDatabase) {
      map['_salt'] = salt;
      map['_hashedPassword'] = hashedPassword;
    }
    return map;
  }

  /// Generates a new salt and hashes the [password] with salt
  void setPassword(String password) {
    // Replaced with existing HashedPassword generation function
    // provided by Aqueduct.
    //    Maximum code reusing! Yay! >_<
    salt = AuthUtility.generateRandomSalt();

    // Add salt to password and hash it
    hashedPassword = AuthUtility.generatePasswordHash(password, salt);
  }

  /// Checks if [passwordToCheck] matches. Takes 500ms before returning, so
  /// we need to use async methods. Should not be needed in most cases since
  /// we could use OAuth.
  Future<bool> checkPassword(String passwordToCheck) async {
    var hash = AuthUtility.generatePasswordHash(passwordToCheck, salt);
    var validation = false;
    await Future.wait([
      // try to avoid timing attack. We assume that any comparison between
      // fixed-sized int lists wouldn't exceed 200ms.
      // TODO: Use other validation methods like XORing buffers.
      Future.delayed(_passwordCheckWaitTime),
      Future(() => validation = hash == hashedPassword),
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
  Map<String, dynamic> asMongoDBEntry() {
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
