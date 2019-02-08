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
  )
});
