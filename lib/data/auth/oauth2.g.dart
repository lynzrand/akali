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
  bool get isBot;
  Set<String> get managedByUsers;
  Set<String> get decendantUsers;
  String get uuidStr;
  String get id;
  BsonBinary get uuidBsonBinary;
  void set _id(Ulid v);
  void set username(String v);
  void set hashedPassword(String v);
  void set salt(String v);
  void set isBot(bool v);
  void set managedByUsers(Set<String> v);
  void set decendantUsers(Set<String> v);
  void set id(String v);
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
      case 'isBot':
        return isBot;
      case 'managedByUsers':
        return managedByUsers;
      case 'decendantUsers':
        return decendantUsers;
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
      case 'isBot':
        isBot = __value;
        return;
      case 'managedByUsers':
        managedByUsers = fromSerialized(__value, () => new Set<String>());
        return;
      case 'decendantUsers':
        decendantUsers = fromSerialized(__value, () => new Set<String>());
        return;
      case 'id':
        id = __value;
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
  Set<String> get scope;
  void set token(String v);
  void set refreshToken(String v);
  void set user(Ulid v);
  void set expires(DateTime v);
  void set scope(Set<String> v);

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
      case 'scope':
        return scope;
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
      case 'scope':
        scope = fromSerialized(__value, () => new Set<String>());
        return;
    }
    throwFieldNotFoundException(__key, 'AccessToken');
  }

  Iterable<String> get keys => AccessTokenClassMirror.fields.keys;
}

abstract class _$AuthCodeSerializable extends SerializableMap {
  String get code;
  String get clientId;
  DateTime get expires;
  void set code(String v);
  void set clientId(String v);
  void set expires(DateTime v);

  operator [](Object __key) {
    switch (__key) {
      case 'code':
        return code;
      case 'clientId':
        return clientId;
      case 'expires':
        return expires;
    }
    throwFieldNotFoundException(__key, 'AuthCode');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case 'code':
        code = __value;
        return;
      case 'clientId':
        clientId = __value;
        return;
      case 'expires':
        expires = fromSerializedDateTime(__value);
        return;
    }
    throwFieldNotFoundException(__key, 'AuthCode');
  }

  Iterable<String> get keys => AuthCodeClassMirror.fields.keys;
}

abstract class _$ClientSerializable extends SerializableMap {
  String get id;
  String get secret;
  String get redirectUri;
  void set id(String v);
  void set secret(String v);
  void set redirectUri(String v);

  operator [](Object __key) {
    switch (__key) {
      case 'id':
        return id;
      case 'secret':
        return secret;
      case 'redirectUri':
        return redirectUri;
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
      case 'redirectUri':
        redirectUri = __value;
        return;
    }
    throwFieldNotFoundException(__key, 'Client');
  }

  Iterable<String> get keys => ClientClassMirror.fields.keys;
}

abstract class _$ErrorResponseSerializable extends SerializableMap {
  String get error;
  String get error_description;
  String get error_uri;
  String get state;
  void set error(String v);
  void set error_description(String v);
  void set error_uri(String v);
  void set state(String v);

  operator [](Object __key) {
    switch (__key) {
      case 'error':
        return error;
      case 'error_description':
        return error_description;
      case 'error_uri':
        return error_uri;
      case 'state':
        return state;
    }
    throwFieldNotFoundException(__key, 'ErrorResponse');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case 'error':
        error = __value;
        return;
      case 'error_description':
        error_description = __value;
        return;
      case 'error_uri':
        error_uri = __value;
        return;
      case 'state':
        state = __value;
        return;
    }
    throwFieldNotFoundException(__key, 'ErrorResponse');
  }

  Iterable<String> get keys => ErrorResponseClassMirror.fields.keys;
}

// **************************************************************************
// MirrorsGenerator
// **************************************************************************

_User__Constructor([positionalParams, namedParams]) => new User();

const $$User_fields_SALT_LENGTH =
    const DeclarationMirror(name: 'SALT_LENGTH', type: int);
const $$User_fields_PASSWORD_CHECK_TIME =
    const DeclarationMirror(name: 'PASSWORD_CHECK_TIME', type: int);
const $$User_fields__id = const DeclarationMirror(name: '_id', type: Ulid);
const $$User_fields_username =
    const DeclarationMirror(name: 'username', type: String);
const $$User_fields_hashedPassword =
    const DeclarationMirror(name: 'hashedPassword', type: String);
const $$User_fields_salt = const DeclarationMirror(name: 'salt', type: String);
const $$User_fields_isBot = const DeclarationMirror(name: 'isBot', type: bool);
const $$User_fields_managedByUsers =
    const DeclarationMirror(name: 'managedByUsers', type: const [Set, String]);
const $$User_fields_decendantUsers =
    const DeclarationMirror(name: 'decendantUsers', type: const [Set, String]);
const $$User_fields_uuidStr =
    const DeclarationMirror(name: 'uuidStr', type: String, isFinal: true);
const $$User_fields_id = const DeclarationMirror(name: 'id', type: String);
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
  'isBot': $$User_fields_isBot,
  'managedByUsers': $$User_fields_managedByUsers,
  'decendantUsers': $$User_fields_decendantUsers,
  'uuidStr': $$User_fields_uuidStr,
  'id': $$User_fields_id,
  'uuidBsonBinary': $$User_fields_uuidBsonBinary,
  'password': $$User_fields_password
}, getters: const [
  '_id',
  'username',
  'hashedPassword',
  'salt',
  'isBot',
  'managedByUsers',
  'decendantUsers',
  'uuidStr',
  'id',
  'uuidBsonBinary'
], setters: const [
  '_id',
  'username',
  'hashedPassword',
  'salt',
  'isBot',
  'managedByUsers',
  'decendantUsers',
  'id',
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
const $$AccessToken_fields_user = const DeclarationMirror(
    name: 'user', type: Ulid, annotations: const [ignore]);
const $$AccessToken_fields_expires =
    const DeclarationMirror(name: 'expires', type: DateTime);
const $$AccessToken_fields_scope =
    const DeclarationMirror(name: 'scope', type: const [Set, String]);

const AccessTokenClassMirror =
    const ClassMirror(name: 'AccessToken', constructors: const {
  '': const FunctionMirror(name: '', $call: _AccessToken__Constructor)
}, fields: const {
  'token': $$AccessToken_fields_token,
  'refreshToken': $$AccessToken_fields_refreshToken,
  'user': $$AccessToken_fields_user,
  'expires': $$AccessToken_fields_expires,
  'scope': $$AccessToken_fields_scope
}, getters: const [
  'token',
  'refreshToken',
  'user',
  'expires',
  'scope'
], setters: const [
  'token',
  'refreshToken',
  'user',
  'expires',
  'scope'
]);

_AuthCode_generate_Constructor([positionalParams, namedParams]) =>
    new AuthCode.generate(positionalParams[0], positionalParams[1]);
_AuthCode__Constructor([positionalParams, namedParams]) => new AuthCode();

const $$AuthCode_fields__CODE_LENGTH =
    const DeclarationMirror(name: '_CODE_LENGTH', type: int);
const $$AuthCode_fields_code =
    const DeclarationMirror(name: 'code', type: String);
const $$AuthCode_fields_clientId =
    const DeclarationMirror(name: 'clientId', type: String);
const $$AuthCode_fields_expires =
    const DeclarationMirror(name: 'expires', type: DateTime);

const AuthCodeClassMirror =
    const ClassMirror(name: 'AuthCode', constructors: const {
  'generate': const FunctionMirror(
      name: 'generate',
      positionalParameters: const [
        const DeclarationMirror(
            name: 'clientId', type: String, isRequired: true),
        const DeclarationMirror(
            name: 'expires', type: DateTime, isRequired: true)
      ],
      $call: _AuthCode_generate_Constructor),
  '': const FunctionMirror(name: '', $call: _AuthCode__Constructor)
}, fields: const {
  'code': $$AuthCode_fields_code,
  'clientId': $$AuthCode_fields_clientId,
  'expires': $$AuthCode_fields_expires
}, getters: const [
  'code',
  'clientId',
  'expires'
], setters: const [
  'code',
  'clientId',
  'expires'
]);

_Client__Constructor([positionalParams, namedParams]) => new Client();

const $$Client_fields_id = const DeclarationMirror(name: 'id', type: String);
const $$Client_fields_secret =
    const DeclarationMirror(name: 'secret', type: String);
const $$Client_fields_redirectUri =
    const DeclarationMirror(name: 'redirectUri', type: String);

const ClientClassMirror =
    const ClassMirror(name: 'Client', constructors: const {
  '': const FunctionMirror(name: '', $call: _Client__Constructor)
}, fields: const {
  'id': $$Client_fields_id,
  'secret': $$Client_fields_secret,
  'redirectUri': $$Client_fields_redirectUri
}, getters: const [
  'id',
  'secret',
  'redirectUri'
], setters: const [
  'id',
  'secret',
  'redirectUri'
]);

_ErrorResponse__Constructor([positionalParams, namedParams]) =>
    new ErrorResponse(positionalParams[0],
        error_description: namedParams['error_description'],
        error_uri: namedParams['error_uri'],
        state: namedParams['state']);

const $$ErrorResponse_fields_error =
    const DeclarationMirror(name: 'error', type: String);
const $$ErrorResponse_fields_error_description =
    const DeclarationMirror(name: 'error_description', type: String);
const $$ErrorResponse_fields_error_uri =
    const DeclarationMirror(name: 'error_uri', type: String);
const $$ErrorResponse_fields_state =
    const DeclarationMirror(name: 'state', type: String);

const ErrorResponseClassMirror =
    const ClassMirror(name: 'ErrorResponse', constructors: const {
  '': const FunctionMirror(
      name: '',
      positionalParameters: const [
        const DeclarationMirror(name: 'error', type: String, isRequired: true)
      ],
      namedParameters: const {
        'error_description': const DeclarationMirror(
            name: 'error_description', type: String, isNamed: true),
        'error_uri': const DeclarationMirror(
            name: 'error_uri', type: String, isNamed: true),
        'state':
            const DeclarationMirror(name: 'state', type: String, isNamed: true)
      },
      $call: _ErrorResponse__Constructor)
}, fields: const {
  'error': $$ErrorResponse_fields_error,
  'error_description': $$ErrorResponse_fields_error_description,
  'error_uri': $$ErrorResponse_fields_error_uri,
  'state': $$ErrorResponse_fields_state
}, getters: const [
  'error',
  'error_description',
  'error_uri',
  'state'
], setters: const [
  'error',
  'error_description',
  'error_uri',
  'state'
]);
