import 'dart:io';
import 'dart:async';
import 'dart:cli';

import 'package:args/args.dart';

import 'package:akali/config.dart';
import 'package:akali/akali.dart';

import 'package:aqueduct/aqueduct.dart';

const String _akaliVersion = '0.0.2';

Future main(List<String> args) async {
  final parser = ArgParser(
    allowTrailingOptions: true,
    usageLineLength: 80,
  )
    ..addOption(
      'config',
      abbr: 'c',
      help: 'Use the file in <path> as configuration.',
      valueHelp: 'path',
    )
    ..addSeparator('')
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
      defaultsTo: './akali/',
    )
    ..addOption(
      'web-root-path',
      help: 'Akali will assume your site is under this path',
      valueHelp: 'path',
      defaultsTo: 'http://localhost:8086/',
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
      help: 'Run Akali in debug mode. Does nothing.',
      // 'Run Akali in debug mode. Will enable hot reloading, and probably other features in the future. This option is only usable when running from a clone of the repository with "--observe=<port>" on.',
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
    print(_akaliTextLogo);
    print('Akali Server $_akaliVersion\n\n');
    print('Usage:');
    print(parser.usage);
    return;
  } else if (runConf['version']) {
    print('Akali Server $_akaliVersion');
    return;
  }

  RequestBody.maxSize = 100 * 1024 * 1024;

  // TODO: add configuration file reader

  var app = Application<AkaliApi>();
  app.options
    ..context = {
      'databaseUri': runConf['database'].toString(),
      'fileStoragePath': runConf['storage-path'],
      'webRootPath': runConf['web-root-path'],
      'useLocalFileStorage': true,
    }
    ..port = int.tryParse(runConf['port'])
    ..address = InternetAddress.anyIPv6;

  await app.start(
    numberOfInstances: int.parse(runConf['isolates']),
  );
}

const _akaliTextLogo = r'''

 ────────────┐
 ╲           │        _   _        _ _ 
  │     __--¯│       /_\ | |____ _| (_)
  │__--¯     │      / _ \| / / _` | | |
  │          │     /_/ \_\_\_\__,_|_|_|
  └──────────┘
''';
