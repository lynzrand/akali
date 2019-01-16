// A custom OAuth 2.0 implementation
import 'dart:async';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:aqueduct/aqueduct.dart';

import 'package:akali/models.dart';
import 'package:akali/data/auth/auth.dart';
export 'package:akali/data/auth/auth.dart';

/// This controller is used ONLY to validate user tokens
class AkaliAuthorizer extends Controller {
  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    request.raw.headers.value('access-token');
    return request;
  }
}
