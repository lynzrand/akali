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
 * 
 * Run `pub run build_runner build` before committing.
 */

library akali.oauth;

import 'package:dson/dson.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ulid/ulid.dart';
import 'package:crypto/crypto.dart';

import 'package:aqueduct/aqueduct.dart';

import 'dart:math';
import 'dart:convert';

import 'dart:async';

part 'oauth2.g.dart';

/// Root class of a Resource Owner defined in RFC6749. Extend it if you need more detailed user
/// information storage (which you 100% will).
///
/// This class is made serializable based on DSON.
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

  @SerializedName('id')
  set id(String value) {
    _id = Ulid.parse(value);
  }

  @SerializedName('_id')
  BsonBinary get uuidBsonBinary {
    // TODO: needs workaround to access the underlying binary representation
    return BsonBinary.fromHexString(_id.toUuid(compact: true));
  }

  String username;

  String hashedPassword;
  String salt;

  bool isBot;
  // These fields should implement ID instead of username.
  Set<String> managedByUsers;
  Set<String> decendantUsers;

  _generateSalt() {
    var randomizer = Random.secure();
    // generate
    salt = _generateRandomString(SALT_LENGTH)
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
  static const _ACCESS_TOKEN_LENGTH = 32;
  static const _REFRESH_TOKEN_LENGTH = 32;

  AccessToken.generate(this.user,
      {Duration validDuration = const Duration(days: 15), dynamic scope}) {
    if (scope is Set<String>)
      this.scope = scope;
    else if (scope is List<String>)
      this.scope = Set<String>.from(scope);
    else if (scope is String)
      this.scope = Set<String>.from(scope.split(' '));
    else
      throw ArgumentError.value(
        scope,
        'The scope of an AccessToken must be a List, Set or String.',
      );

    this.expires = DateTime.now().toUtc().add(validDuration);

    this.token = _generateRandomString(_ACCESS_TOKEN_LENGTH);
    this.refreshToken = _generateRandomString(_REFRESH_TOKEN_LENGTH);
  }

  String token;
  String refreshToken;

  String user;
  String client;
  DateTime expires;
  Set<String> scope;
}

@serializable
class AuthCode {
  static const _CODE_LENGTH = 26;

  AuthCode.generate(this.clientId, this.expires) {
    var code = _generateRandomString(_CODE_LENGTH);
    this.code = code;
  }

  AuthCode();
  String code;
  String clientId;
  DateTime expires;
}

@serializable
class Client {
  String id;

  String name;
  String desc;

  String secret;
  String redirectUri;
}

_generateRandomString(int length) {
  var randomizer = Random.secure();
  const charSet = 'ybndrfg8ejkmcpqxot1uwisza345h769';
  // generate
  return 
      Iterable.generate(length, (_) => charSet[randomizer.nextInt(32)]).join();
}

abstract class OAuthDatabase<U extends User, T extends AccessToken,
    A extends AuthCode, C extends Client> {
  FutureOr<U> addUser(U user);
  FutureOr<C> findClientById(String clientID);
  FutureOr<void> grantedAuthCode(A code);
}

/*
 * # Method to implement:
 * 
 * ## Auth Code grant type
 * 
 * - RequestAuthCode(response_type, client_id, redirect_uri, scope, state)
 *   => AuthCode(code), state
 *    | ErrorResponse(error, error_description, error_uri, state)
 * 
 * - RequestAccessToken(grant_type, code, redirect_uri, client_id)
 *   => AccessToken(token, type, expires, refresh_token, ...other_params)
 *    | ErrorResponse()
 */

// class OAuthManager<D extends OAuthDatabase, U extends User, A extends AuthCode,
//     T extends AccessToken, C extends Client> {}

abstract class _AuthCodeErrorCodes {
  static const UNAUTHORIZED_CLIENT = 'unauthorized_client';
  static const ACCESS_DENIED = 'access_denied';
  static const UNSUPPORTED_RESPONSE_TYPE = 'unsupported_response_type';
  static const INVALID_SCOPE = 'invalid_scope';
  static const SERVER_ERROR = 'server_error';
  static const TEMPORARILY_UNAVALIABLE = 'temporarily_unavaliable';
}

@serializable
class ErrorResponse {
  String error;
  String error_description;
  String error_uri;
  String state;
  ErrorResponse(this.error,
      {this.error_description, this.error_uri, this.state});
}

class AuthCodeGranter<D extends OAuthDatabase, C extends Client>
    extends ResourceController {
  final D database;
  AuthCodeGranter(this.database);

  static const _CODE_EXPIRES_TIME = Duration(minutes: 10);

  @Operation.post()
  Future<Response> grantAuthCode(
      @Bind.query('response_type') String responseType,
      @Bind.query('client_id') String clientID,
      @Bind.query('redirect_uri') String redirectUri,
      @Bind.query('scope') String scope,
      @Bind.query('state') String state) async {
    // Unsupported Response Type
    if (responseType != 'code')
      throw Response.badRequest(
        body: ErrorResponse(
          _AuthCodeErrorCodes.UNSUPPORTED_RESPONSE_TYPE,
          state: state,
        ),
      );

    C client = await database.findClientById(clientID);

    // Unmatching Redirect URI
    if (redirectUri != null && client.redirectUri != redirectUri) {
      throw Response.badRequest(
        body: ErrorResponse(
          _AuthCodeErrorCodes.UNAUTHORIZED_CLIENT,
          state: state,
        ),
      );
    }

    // TODO: add scope verification and storage

    var code = AuthCode.generate(
        clientID, DateTime.now().toUtc().add(_CODE_EXPIRES_TIME));

    await database.grantedAuthCode(code);

    redirectUri = redirectUri ?? client.redirectUri;
    return Response(
        302,
        {
          'Location': redirectUri +
              Uri.encodeQueryComponent(
                'code=${code.code}&state=$state',
              )
        },
        'You are being redirected.');
  }
}

class AccessTokenGranter extends ResourceController {
  @Operation.post('/code')
  Response tokenGranter(
    @Bind.query('code') code,
  ) {}
}
