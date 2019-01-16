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

enum UserPrivilege {
  PostImage,
  DeleteImage,
  PostComment,
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

  Set<UserPrivilege> previleges;

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
  Set<UserPrivilege> privileges;

  UserAccessToken(
    token,
    name, {
    this.privileges,
    otherInfo,
    expires,
  }) : super(token, name, otherInfo: otherInfo, expires: expires);
}
