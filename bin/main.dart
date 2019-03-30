library akali;

import 'dart:io';
import 'dart:async';
import 'dart:cli';

import 'package:args/args.dart';

import 'package:akali/akali.dart';
import 'package:akali/logger/logger.dart';

import 'package:aqueduct/aqueduct.dart';

const String _akaliVersion = '0.0.2';

Future main(List<String> args) async {
  // hierarchicalLoggingEnabled = true;

  final parser = ArgParser(
    allowTrailingOptions: true,
    usageLineLength: 80,
  )

    // === Options ===
    ..addSeparator('Options')
    ..addOption(
      'config',
      abbr: 'c',
      help: 'Use the file in <path> as configuration.',
      valueHelp: 'path',
    )
    ..addOption(
      'database',
      abbr: 'D',
      help: 'Use <uri> as your database',
      valueHelp: 'uri',
      defaultsTo: 'mongodb://localhost',
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
      defaultsTo: 'akali/',
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
      'verbose',
      abbr: 'V',
      help: 'Logs more information. Allowed values: '
          'numbers (if you know what they mean), '
          'shout, severe, warning, info, config, fine, finer, finest, all',
      valueHelp: 'verbosity',
      defaultsTo: 'warning',
    )
    // ..addOption(
    //   'debug',
    //   abbr: 'd',
    //   help: 'Run Akali in debug mode. Does nothing.',
    //   // 'Run Akali in debug mode. Will enable hot reloading, and probably other features in the future. This option is only usable when running from a clone of the repository with "--observe=<port>" on.',
    //   valueHelp: 'port',
    // )

    // === Flags ===
    ..addSeparator('Flags')
    ..addFlag('debug')

    // === Extras ===
    ..addSeparator('Extras')
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

  var runtimeVerbosity = runtimeVerbosityDeterminer(runConf['verbose']);

  RequestBody.maxSize = 100 * 1024 * 1024;

  String rootPath = runConf['storage-path'];
  if (!rootPath.endsWith('/')) rootPath += '/';
  String webRootPath = runConf['web-root-path'];
  if (!webRootPath.endsWith('/')) webRootPath += '/';

  // TODO: add configuration file reader

  var app = Application<AkaliApi>();
  app.options
    ..context = {
      //TODO::Protocol analysis
      'databaseUri': runConf['database'].toString(),
      'fileStoragePath': rootPath,
      'webRootPath': webRootPath,
      'useLocalFileStorage': true,
      'verbosity': runtimeVerbosity,
    }
    ..port = int.tryParse(runConf['port'])
    ..address = InternetAddress.anyIPv6;

  app.logger.parent.level = runtimeVerbosity;
  app.logger.onRecord.listen(logHandlerFactory(runtimeVerbosity));

  app.logger.log(
    Level.INFO,
    "Akali $_akaliVersion: Starting up at ${DateTime.now()}",
  );
  app.logger.log(Level.INFO, "Log level $runtimeVerbosity");

  try {
    await app.start(
      numberOfInstances: int.parse(runConf['isolates']),
    );
  } catch (e, stack) {
    print("Akali has encountered an error, and must close now.\n Error:");
    print(e);
    print("\nStacktrace:");
    print(stack);
    exit(-1);
  }
}

Level runtimeVerbosityDeterminer(String verbosity) {
  if (verbosity == null) return Level.WARNING;
  var numericVerbosity = int.tryParse(verbosity);
  if (numericVerbosity == null) {
    verbosity = verbosity.toLowerCase();
    switch (verbosity) {
      case 'shout':
        return Level.SHOUT;
      case 'severe':
        return Level.SEVERE;
      case 'warning':
        return Level.WARNING;
      case 'info':
        return Level.INFO;
      case 'config':
        return Level.CONFIG;
      case 'fine':
        return Level.FINE;
      case 'finer':
        return Level.FINER;
      case 'finest':
        return Level.FINEST;
      case 'all':
        return Level.ALL;
      default:
        throw ArgumentError.value(
            verbosity, '--verbose=', 'verbosity not supported');
    }
  } else {
    return Level('custom', numericVerbosity);
  }
}

const _akaliTextLogo = r'''

 ────────────┐
 ╲           │        _   _        _ _ 
  │     __--¯│       /_\ | |____ _| (_)
  │__--¯     │      / _ \| / / _` | | |
  │          │     /_/ \_\_\_\__,_|_|_|
  └──────────┘
''';
