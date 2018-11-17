import 'dart:io';
import 'dart:async';
import 'dart:cli';
import 'package:rpc/rpc.dart';
import 'package:args/args.dart';

import 'api/api.dart';
import 'config.dart';
import 'api/loadBalancer.dart';

Future main(List<String> args) async {
  final parser = ArgParser()..addFlag("debug", abbr: "d", negatable: false);
  parser.parse(args);

  var loadBalancer = AkaliLoadBalancer(1);
  await loadBalancer.init();
}

Configuration argParser(List<String> args, [Configuration cfg]) {
  cfg ??= new Configuration();

  return cfg;
}
