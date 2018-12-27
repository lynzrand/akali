import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';
import 'package:ulid/ulid.dart';
import 'package:crypto/crypto.dart';

class _AkaliUser extends ManagedObject {
  /// How much salt would you add on your hash?
  static const _hashSaltLength = 64;

  /// How many time would you like the user to wait before validating?
  static final _passwordCheckWaitTime = Duration(milliseconds: 200);

  /// User identifier
  Ulid id;

  /// Username, should be unique across platform
  String username;

  /// Password hash that should be stored into database
  List<int> _hashedPassword;

  /// The salt value used to calculate the password
  String _salt;

  _AkaliUser() {}

  _AkaliUser.fromMap(Map<String, dynamic> map) {}

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
