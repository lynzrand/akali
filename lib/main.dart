import 'dart:io';
import 'dart:async';
import 'dart:cli';
import 'package:rpc/rpc.dart';
import 'package:args/args.dart';

import 'api/api.dart';
import 'config.dart';
import 'api/loadBalancer.dart';

final ApiServer _api = ApiServer();

Future main(List<String> args) async {
  final parser = ArgParser()..addFlag("debug", abbr: "d", negatable: false);
  parser.parse(args);

  // _api.addApi(AkaliApi());
  // var server = await HttpServer.bind(InternetAddress.anyIPv6, 8086,shared: true);

  print("Akali listening at any:8086");

  var loadBalancer = AkaliLoadBalancer(5);
  await loadBalancer.init();
  // server.listen((data) => print(data));
}

Configuration argParser(List<String> args, [Configuration cfg]) {
  cfg ??= new Configuration();

  return cfg;
}
