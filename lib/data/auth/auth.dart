import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:akali/data/helpers/jsonConversionHelpers.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';
import 'package:aqueduct/src/auth/auth.dart';
import 'package:akali/data/db/db.dart';
import 'package:ulid/ulid.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:json_annotation/json_annotation.dart';
part 'auth.g.dart';

enum UserLevel {
  Guest,
  User,
  Manager,
  Admin,
}
/*
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
}*/

const List<String> userPrivileges = [
  'guest.viewContents',
  'user.sendContent',
  'user.editOwnContent',
  'user.deleteOwnContent',
  'user.sendComment',
  'user.editOwnComment',
  'user.deleteOwnComment',
  'user.editOwnTags',
  'user.editAllTags',
  'user.reportContent',
  'admin.editSiteContent',
  'admin.deleteSiteContent',
  'admin.approveContent',
  'admin.deleteSiteComment',
  'admin.accessStatistics',
  'admin.fullControl',
];

@JsonSerializable(disallowUnrecognizedKeys: false)
class AkaliUser extends Serializable implements ResourceOwner {
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
  int id;

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
  @JsonKey(ignore: true)
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
  @JsonKey(ignore: true)
  String hashedPassword;

  /// Salt used to calculate hash
  @JsonKey(ignore: true)
  String salt;

  @JsonKey(fromJson: authScopeFromMap, toJson: authScopeToMap)
  List<AuthScope> scopes;

  AkaliUser() : super();

  factory AkaliUser.fromMap(final Map<String, dynamic> map) {
    return _$AkaliUserFromJson(map);
  }

  Map<String, dynamic> asMongoDBEntry() {
    return asMap(true);
  }

  Map<String, dynamic> asMap([final bool toDatabase = false]) {
    var map = _$AkaliUserToJson(this);
    map['scopes'] = scopes;
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

  @override
  void readFromMap(Map<String, dynamic> object) {
    this._id = object['_id'];
    this.id = object['_id'];
    this.username = object['username'];
    this.scopes = authScopeFromMap(object['scopes']);
    this.hashedPassword = object['_hashedPassword'];
    this.salt = object['_salt'];
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

  SeriManagedToken.readFromMap(Map<String, dynamic> map) {
    map['scope'] = (map['scope'] as List).join(' ');
    super.readFromMap(map);
  }
}

class SeriAuthClient extends ManagedAuthClient {
  /* 
    /// The client identifier of this client.
  ///
  /// An OAuth 2.0 client represents the client application that authorizes on behalf of the user
  /// with this server. For example 'com.company.mobile_apps'. This value is required.
  @Column(primaryKey: true)
  String id;

  /// The client secret, hashed with [salt], if this client is confidential.
  ///
  /// A confidential client requires its secret to be included when used. If this value is null,
  /// this client is a public client.
  @Column(nullable: true)
  String hashedSecret;

  /// The hashing salt for [hashedSecret].
  @Column(nullable: true)
  String salt;

  /// The redirect URI for the authorization code flow.
  ///
  /// This value must be a valid URI to allow the authorization code flow. A user agent
  /// is redirected to this URI with an authorization code that can be exchanged
  /// for a token. Only confidential clients may have a value.
  @Column(nullable: true)
  String redirectURI;

  /// Scopes that this client allows.
  ///
  /// If null, this client does not support scopes and all tokens are valid for all routes.
  @Column(nullable: true)
  String allowedScope;

  /// Tokens that have been issued for this client.
  ManagedSet<ManagedAuthToken> tokens;
  */
  SeriAuthClient() : super();
  SeriAuthClient.fromClient(AuthClient client) : super.fromClient(client);

  Map<String, dynamic> asMongoDBEntry() {
    return {
      "id": id,
      "hashedSecret": hashedSecret,
      "hashedCode": hashCode,
      "redirectURI": redirectURI,
      "allowedScope": allowedScope.split(' '),
      "tokenIDs": tokens.map((token) => token.id)
    };
  }

  /// Reads the client data from a map.
  ///
  /// **CAUTION: This method does not read the tokens associated with this**
  /// **client on itself! Please make sure you assign them afterwards or pass
  /// them under the "tokenMaps" key!**
  ///
  /// This is a workaround for compatibility between
  /// PostgreSQL and MongoDB.
  SeriAuthClient.readFromMap(Map<String, dynamic> map) {
    super.readFromMap(map);

    // Pass token maps if they are already present
    if (map['tokenMaps'] != null &&
        map['tokenMaps'] is List<Map<String, dynamic>>) {
      final tokenMaps = map['tokenMaps'] as List<Map<String, dynamic>>;
      this.tokens = ManagedSet.from(tokenMaps.map((map) {
        return SeriManagedToken.readFromMap(map);
      }));
    }
  }
}
