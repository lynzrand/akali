import 'dart:io';
import 'dart:async';
import 'package:rpc/rpc.dart';

import 'api/api.dart';
import 'config.dart';

final ApiServer _api = ApiServer();

Future main(List<String> args) async {
  _api.addApi(AkaliApi());
  var server = await HttpServer.bind(InternetAddress.anyIPv6, 8086);

  server.listen(_api.httpRequestHandler);
}

Configuration argParser(List<String> args, [Configuration cfg]) {
  cfg ??= new Configuration();

  return cfg;
}
