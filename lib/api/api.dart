import 'package:rpc/rpc.dart';
import 'dart:io';

/// Runs in an Isolate!
void handleApiCall() {}

@ApiClass(
  name: 'akali',
  version: 'v1',
)
class AkaliApi {}
