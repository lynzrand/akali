import 'dart:io';
import 'dart:async';
import 'dart:cli';
import 'package:rpc/rpc.dart';
import 'package:args/args.dart';

import 'package:akali/config.dart';
import 'package:akali/akali.dart';

const String _akaliVersion = "0.0.1";

Future main(List<String> args) async {
  final parser = ArgParser(allowTrailingOptions: true)
    ..addOption(
      "database",
      abbr: "D",
      help: "Use <database_uri> as your database",
      valueHelp: "database_uri",
      defaultsTo: "127.0.0.1:27017",
    )
    ..addOption(
      "port",
      abbr: 'p',
      help: "Run Akali on <port>",
      valueHelp: "port",
      defaultsTo: "8086",
    )
    ..addFlag(
      "debug",
      abbr: "d",
      help: "Run Akali in debug mode (does not affect anything for now)",
      negatable: false,
    )
    ..addFlag(
      "version",
      abbr: "v",
      help: "Show version and exit",
      negatable: false,
    )
    ..addFlag(
      "help",
      abbr: "h",
      help: "Show this help message",
      negatable: false,
    );
  var runConf = parser.parse(args);

  if (runConf['help']) {
    print('''
Akali v$_akaliVersion

Usage:
    ''');
    print(parser.usage);
    return;
  } else if (runConf['version']) {
    print('Akali Server $_akaliVersion');
    return;
  }

  var loadBalancer = AkaliLoadBalancer(
    1,
    serverPort: int.tryParse(runConf['port']),
  );
  await loadBalancer.init();
}
