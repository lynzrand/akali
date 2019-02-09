/* 
 * This is a custom OAuth2 implementation based on the RFC6749 document
 * to avoid using aqueduct's managed_auth package (which is hardly usable in
 * mongodb environments).
 *
 * This implementation  uses ULIDs for creating identifiers. This ULID
 * implementation uses UUID format to store the IDs, and works with
 * the bonus of being able to sort by time.
 * 
 * This implementation relies on DSON for serializing/deserializing data.
 * DSON together with its generated code provides the fastest non-handwritten
 * serialization/deserialization method running speed among tests, so it could
 * help this thing to be a high-performance framework.
 */

library akali.oauth;

import 'package:dson/dson.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ulid/ulid.dart';
import 'package:crypto/crypto.dart';

import 'dart:math';
import 'dart:convert';

part 'oauth2.g.dart';

/// Root class of a Resource Owner defined in RFC6749. Extend it if you need more detailed user
/// information storage (which you 100% will).
///
/// This class is serializable based on DSON.
/// See https://pub.dartlang.org/packages/dson#extend-serializable-objects
/// for information on how to extend this class.
///
/// This class used `User` to avoid collision with Aqueduct's implementation.
@serializable
class User {
  static const int SALT_LENGTH = 16;
  static const int PASSWORD_CHECK_TIME = 400;

  // Screw those ObjectIDs and UUIDs. Just use Ulid for simplicity.
  /// The unique identifier generated when the user is created.
  @ignore
  Ulid _id;

  /// Basically just renders its ULID into UUID format.
  /// It's still sortable so no worries.
  String get uuidStr {
    return _id.toUuid(compact: true);
  }

  /// Returns the canonical representation of the uuid.
  ///
  /// This method should be used in most times when converting the ID
  /// to string is involved.
  @SerializedName('id')
  String get id {
    return _id.toCanonical();
  }

  @SerializedName('_id')
  BsonBinary get uuidBsonBinary {
    // TODO: needs workaround to access the underlying binary representation
    return BsonBinary.fromHexString(_id.toUuid(compact: true));
  }

  String username;

  String hashedPassword;
  String salt;

  _generateSalt() {
    var randomizer = Random.secure();
    // generate
    salt = String.fromCharCodes(
        Iterable.generate(SALT_LENGTH, (_) => randomizer.nextInt(92) + 32));
    // clear hashed password because it's no longer usable
    hashedPassword = null;
  }

  set password(String value) {
    _generateSalt();
    hashedPassword = base64Encode(sha256.convert(value.codeUnits).bytes);
  }

  Map<String, dynamic> toInfoMap() {
    return toMap(this, exclude: ['hashedPassword', 'salt', '_id']);
  }

  Map<String, dynamic> toStorageMap() {
    return toMap(this);
  }
}

@serializable
class AccessToken {
  String token;
  String refreshToken;
  Ulid user;
  DateTime expires;
}

@serializable
class Client {
  String id;
  String secret;
}
