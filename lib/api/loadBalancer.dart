import 'dart:io';
import 'dart:isolate';
import 'dart:async';
import 'dart:math';

import 'package:isolate/load_balancer.dart';
import 'package:isolate/isolate_runner.dart';
import 'package:isolate/ports.dart';

import 'package:rpc/rpc.dart';

import 'package:akali/api/api.dart';
import 'package:akali/data/db.dart';

/// Akali's default Isolate runner implementation.
class AkaliLoadBalancer {
  // HttpServer mainServer;
  /// Port to run HTTP server on
  int serverPort;

  /// Number of isolates to run in parallel
  int isolateCount;

  ReceivePort port;
  SendPort send;

  /// Database that this Akali instance is running on
  String databaseUri;

  // LoadBalancer _loadBalancer;
  /// All isolate runners used here
  List<IsolateRunner> _runners;

  /// Maximum crashes allowed for a single instance
  int maxCrashCount;
  List<int> _crashCount;

  /// A function which will be run when creating isolates
  Function createIsolateFunction;

  /// Create a new Akali server with [isolateCount] isolates, running at
  /// port [serverPort], uses database at [databaseUri], and creates isolates
  /// using [createIsolateFunction].
  ///
  /// **Remember to run [init()] after creation!**
  AkaliLoadBalancer(
    this.isolateCount, {
    // this.mainServer,
    this.serverPort = 8086,
    this.maxCrashCount = 10,
    this.createIsolateFunction = createAkaliIsolate,
    this.databaseUri = "127.0.0.1:27017",
  }) {
    port = ReceivePort();
    _crashCount = new List<int>.filled(isolateCount, 0);
  }

  /// Initializes the Akali server.
  Future<void> init() async {
    _runners = await Future.wait(
        Iterable.generate(isolateCount, (_) => IsolateRunner.spawn()));
    // _loadBalancer = LoadBalancer(_runners);

    _runners.forEach(
      (i) => i
          .run<void, AkaliIsolateArgs>(
            createIsolateFunction,
            AkaliIsolateArgs(port: serverPort, databaseUri: databaseUri),
          )
          .catchError(
            (e) => _runnerCrashCallback(i, e),
          ),
    );

    // _loadBalancer.runMultiple(
    //   isolateCount,
    //   createAkaliIsolate,
    //   <String, dynamic>{},
    // );
  }

  /// Callback function to be called when a runner crashed.
  _runnerCrashCallback(IsolateRunner i, Error e) {
    int index = _runners.indexWhere((runner) => runner == i);
    _crashCount[index]++;
    if (_crashCount[index] < maxCrashCount) {
      i.run(createIsolateFunction,
          AkaliIsolateArgs(port: serverPort, databaseUri: databaseUri));
    } else {
      print("Isolate #$i crashed too many times. Shutting down.");
    }
  }
}

class AkaliIsolateArgs {
  AkaliIsolateArgs({
    this.port,
    this.isolateName,
    this.databaseUri = '127.0.0.1:27017',
  });
  int port;
  int isolateName;
  String databaseUri;
  // TODO: add Logger
  // TODO: add isolate port
}

/// Akali's defualt function to create an isolate.
Future<void> createAkaliIsolate(AkaliIsolateArgs args) async {
  var isolate = new AkaliIsolate(args);
  await isolate.init();
  return;
}

/// A HTTP server running in an isolate.
///
/// TODO: add HTTPS compatibility (though in most cases not needed)
class AkaliIsolate {
  HttpServer _server;
  int port;
  int isolateName;
  StreamSubscription listening;
  ApiServer _apiServer;

  String databaseUri;
  AkaliDatabase _db;

  AkaliIsolate(AkaliIsolateArgs args) {
    isolateName = args.isolateName ?? Random().nextInt(99);
    port = args.port;
    databaseUri = args.databaseUri;
  }

  void init() async {
    _db = AkaliDatabase(databaseUri);
    await _db.init();

    _apiServer = ApiServer();
    _apiServer.addApi(AkaliApi(_db));

    _server =
        await HttpServer.bind(InternetAddress.anyIPv4, port, shared: true);
    listening = _server.listen(
      _handleRequest,
      onDone: _handleRequestDone,
      onError: _handleRequestError,
    );
    // TODO: put this to logger
    print('#$isolateName listening at localhost:$port');
  }

  void close() {
    listening.cancel();
  }

  _handleRequest(HttpRequest req) {
    // TODO: put this to logger too
    print(
        "#$isolateName: ${req.connectionInfo.remoteAddress} ${req.method} ${req.requestedUri}");
    _apiServer.httpRequestHandler(req);
  }

  void _handleRequestDone() {
    // TODO: and this
    print("#$isolateName: done");
  }

  void _handleRequestError(dynamic error, StackTrace stackTrace) {
    // TODO: and also this.
    print("#$isolateName: ERROR!\n$error\n$stackTrace");
  }
}
