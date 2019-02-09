// GENERATED CODE - DO NOT MODIFY BY HAND

part of akali.oauth;

// **************************************************************************
// DsonGenerator
// **************************************************************************

abstract class _$UserSerializable extends SerializableMap {
  Ulid get _id;
  String get username;
  String get hashedPassword;
  String get salt;
  String get uuidStr;
  String get id;
  BsonBinary get uuidBsonBinary;
  void set _id(Ulid v);
  void set username(String v);
  void set hashedPassword(String v);
  void set salt(String v);
  void set password(String v);
  dynamic _generateSalt();
  Map<String, dynamic> toInfoMap();
  Map<String, dynamic> toStorageMap();

  operator [](Object __key) {
    switch (__key) {
      case '_id':
        return _id;
      case 'username':
        return username;
      case 'hashedPassword':
        return hashedPassword;
      case 'salt':
        return salt;
      case 'uuidStr':
        return uuidStr;
      case 'id':
        return id;
      case 'uuidBsonBinary':
        return uuidBsonBinary;
      case '_generateSalt':
        return _generateSalt;
      case 'toInfoMap':
        return toInfoMap;
      case 'toStorageMap':
        return toStorageMap;
    }
    throwFieldNotFoundException(__key, 'User');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case '_id':
        _id = fromSerialized(__value, () => new Ulid());
        return;
      case 'username':
        username = __value;
        return;
      case 'hashedPassword':
        hashedPassword = __value;
        return;
      case 'salt':
        salt = __value;
        return;
      case 'password':
        password = __value;
        return;
    }
    throwFieldNotFoundException(__key, 'User');
  }

  Iterable<String> get keys => UserClassMirror.fields.keys;
}

abstract class _$AccessTokenSerializable extends SerializableMap {
  String get token;
  String get refreshToken;
  Ulid get user;
  DateTime get expires;
  void set token(String v);
  void set refreshToken(String v);
  void set user(Ulid v);
  void set expires(DateTime v);

  operator [](Object __key) {
    switch (__key) {
      case 'token':
        return token;
      case 'refreshToken':
        return refreshToken;
      case 'user':
        return user;
      case 'expires':
        return expires;
    }
    throwFieldNotFoundException(__key, 'AccessToken');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case 'token':
        token = __value;
        return;
      case 'refreshToken':
        refreshToken = __value;
        return;
      case 'user':
        user = fromSerialized(__value, () => new Ulid());
        return;
      case 'expires':
        expires = fromSerializedDateTime(__value);
        return;
    }
    throwFieldNotFoundException(__key, 'AccessToken');
  }

  Iterable<String> get keys => AccessTokenClassMirror.fields.keys;
}

abstract class _$ClientSerializable extends SerializableMap {
  String get id;
  String get secret;
  void set id(String v);
  void set secret(String v);

  operator [](Object __key) {
    switch (__key) {
      case 'id':
        return id;
      case 'secret':
        return secret;
    }
    throwFieldNotFoundException(__key, 'Client');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case 'id':
        id = __value;
        return;
      case 'secret':
        secret = __value;
        return;
    }
    throwFieldNotFoundException(__key, 'Client');
  }

  Iterable<String> get keys => ClientClassMirror.fields.keys;
}

// **************************************************************************
// MirrorsGenerator
// **************************************************************************

_User__Constructor([positionalParams, namedParams]) => new User();

const $$User_fields_SALT_LENGTH =
    const DeclarationMirror(name: 'SALT_LENGTH', type: int);
const $$User_fields_PASSWORD_CHECK_TIME =
    const DeclarationMirror(name: 'PASSWORD_CHECK_TIME', type: int);
const $$User_fields__id = const DeclarationMirror(
    name: '_id', type: Ulid, annotations: const [ignore]);
const $$User_fields_username =
    const DeclarationMirror(name: 'username', type: String);
const $$User_fields_hashedPassword =
    const DeclarationMirror(name: 'hashedPassword', type: String);
const $$User_fields_salt = const DeclarationMirror(name: 'salt', type: String);
const $$User_fields_uuidStr =
    const DeclarationMirror(name: 'uuidStr', type: String, isFinal: true);
const $$User_fields_id =
    const DeclarationMirror(name: 'id', type: String, isFinal: true);
const $$User_fields_uuidBsonBinary = const DeclarationMirror(
    name: 'uuidBsonBinary', type: BsonBinary, isFinal: true);
const $$User_fields_password =
    const DeclarationMirror(name: 'password', type: String);

const UserClassMirror = const ClassMirror(name: 'User', constructors: const {
  '': const FunctionMirror(name: '', $call: _User__Constructor)
}, fields: const {
  '_id': $$User_fields__id,
  'username': $$User_fields_username,
  'hashedPassword': $$User_fields_hashedPassword,
  'salt': $$User_fields_salt,
  'uuidStr': $$User_fields_uuidStr,
  'id': $$User_fields_id,
  'uuidBsonBinary': $$User_fields_uuidBsonBinary,
  'password': $$User_fields_password
}, getters: const [
  '_id',
  'username',
  'hashedPassword',
  'salt',
  'uuidStr',
  'id',
  'uuidBsonBinary'
], setters: const [
  '_id',
  'username',
  'hashedPassword',
  'salt',
  'password'
], methods: const {
  '_generateSalt': const FunctionMirror(
    name: '_generateSalt',
    returnType: dynamic,
  ),
  'toInfoMap': const FunctionMirror(
    name: 'toInfoMap',
    returnType: const [
      Map,
      const [String, dynamic]
    ],
  ),
  'toStorageMap': const FunctionMirror(
    name: 'toStorageMap',
    returnType: const [
      Map,
      const [String, dynamic]
    ],
  )
});

_AccessToken__Constructor([positionalParams, namedParams]) => new AccessToken();

const $$AccessToken_fields_token =
    const DeclarationMirror(name: 'token', type: String);
const $$AccessToken_fields_refreshToken =
    const DeclarationMirror(name: 'refreshToken', type: String);
const $$AccessToken_fields_user =
    const DeclarationMirror(name: 'user', type: Ulid);
const $$AccessToken_fields_expires =
    const DeclarationMirror(name: 'expires', type: DateTime);

const AccessTokenClassMirror =
    const ClassMirror(name: 'AccessToken', constructors: const {
  '': const FunctionMirror(name: '', $call: _AccessToken__Constructor)
}, fields: const {
  'token': $$AccessToken_fields_token,
  'refreshToken': $$AccessToken_fields_refreshToken,
  'user': $$AccessToken_fields_user,
  'expires': $$AccessToken_fields_expires
}, getters: const [
  'token',
  'refreshToken',
  'user',
  'expires'
], setters: const [
  'token',
  'refreshToken',
  'user',
  'expires'
]);

_Client__Constructor([positionalParams, namedParams]) => new Client();

const $$Client_fields_id = const DeclarationMirror(name: 'id', type: String);
const $$Client_fields_secret =
    const DeclarationMirror(name: 'secret', type: String);

const ClientClassMirror = const ClassMirror(
    name: 'Client',
    constructors: const {
      '': const FunctionMirror(name: '', $call: _Client__Constructor)
    },
    fields: const {
      'id': $$Client_fields_id,
      'secret': $$Client_fields_secret
    },
    getters: const [
      'id',
      'secret'
    ],
    setters: const [
      'id',
      'secret'
    ]);
