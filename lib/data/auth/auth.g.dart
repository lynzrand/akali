// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AkaliUser _$AkaliUserFromJson(Map<String, dynamic> json) {
  return AkaliUser()
    ..id = json['id'] as int
    ..username = json['username'] as String
    ..scopes = json['scopes'] == null
        ? null
        : authScopeFromMap(json['scopes'] as List<String>);
}

Map<String, dynamic> _$AkaliUserToJson(AkaliUser instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'scopes': instance.scopes == null ? null : authScopeToMap(instance.scopes)
    };
