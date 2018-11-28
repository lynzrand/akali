import 'dart:io';
import 'dart:async';
import 'dart:cli';
import 'package:rpc/rpc.dart';
import 'package:args/args.dart';

import 'package:akali/config.dart';
import 'package:akali/akali.dart';

import 'package:aqueduct/aqueduct.dart';

const String _akaliVersion = '0.0.1';

Future main(List<String> args) async {
  final parser = ArgParser(
    allowTrailingOptions: true,
    usageLineLength: 80,
  )
    ..addOption(
      'database',
      abbr: 'D',
      help: 'Use <uri> as your database',
      valueHelp: 'uri',
      defaultsTo: '127.0.0.1:27017',
    )
    ..addOption(
      'port',
      abbr: 'p',
      help: 'Run Akali on <port>',
      valueHelp: 'port',
      defaultsTo: '8086',
    )
    ..addOption(
      'storage-path',
      abbr: 'S',
      help: 'Akali will store files under this path',
      valueHelp: 'path',
      defaultsTo: '/data/akali',
    )
    ..addOption(
      'isolates',
      abbr: 'i',
      help: 'Run Akali with <number> isolates',
      valueHelp: 'number',
      defaultsTo: '1',
    )
    ..addOption(
      'debug',
      abbr: 'd',
      help:
          'Run Akali in debug mode. Will enable hot reloading, and probably other features in the future. This option is only usable when running from a clone of the repository with "--observe=<port>" on.',
      valueHelp: 'port',
    )
    ..addFlag(
      'version',
      abbr: 'v',
      help: 'Show version and exit',
      negatable: false,
    )
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Show this help message',
      negatable: false,
    );
  var runConf = parser.parse(args);

  if (runConf['help']) {
    print('Usage:');
    print(parser.usage);
    return;
  } else if (runConf['version']) {
    print('Akali Server $_akaliVersion');
    return;
  }

  // TODO: add configuration file reader

  var app = Application<AkaliApi>();
  app.options
    ..context = {
      'databaseUri': runConf['database'].toString(),
      'fileStoragePath': runConf['storage-path'],
      'useLocalFileStorage': true,
    }
    ..port = int.tryParse(runConf['port'])
    ..address = InternetAddress.anyIPv6;

  app.logger.level = Level.ALL;

  await app.start(
    numberOfInstances: int.parse(runConf['isolates']),
  );

  // Deprecated code. Once switched to Aqueduct, they will be deleted.
  // _____
  // var loadBalancer = AkaliLoadBalancer(
  //   1,
  //   serverPort: int.tryParse(runConf['port']),
  //   databaseUri: runConf['database'].toString(),
  //   fileStoragePath: runConf['storage-path'],
  //   useLocalFileStorage: true,
  // );
  // await loadBalancer.init();
}
