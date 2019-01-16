// A custom OAuth 2.0 implementation
import 'dart:async';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:aqueduct/aqueduct.dart';

import 'package:akali/models.dart';
import 'package:akali/data/auth/auth.dart';
export 'package:akali/data/auth/auth.dart';

// TODO:
// Dig into the OAuth 2 implementation of Aqueduct and write a custom
// implementation reusing as many parts as possible. The original implementation
// uses PostgreSQL, so we cannot directly use it as we also need compatibility
// with MongoDB.
//
// Long way to go for Akali. *sigh*
