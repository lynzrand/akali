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

class AkaliLoadBalancer {
  HttpServer mainServer;
  int serverPort;
  int isolateCount;
  ReceivePort port;
  SendPort send;

  String databaseUri;

  LoadBalancer _loadBalancer;
  List<IsolateRunner> _runners;

  int maxCrashCount;
  List<int> _crashCount;

  Function createIsolateFunction;

  AkaliLoadBalancer(
    this.isolateCount, {
    this.mainServer,
    this.serverPort = 8086,
    this.maxCrashCount = 10,
    this.createIsolateFunction = createAkaliIsolate,
    this.databaseUri = "127.0.0.1:27017",
  }) {
    port = ReceivePort();
    _crashCount = new List<int>.filled(isolateCount, 0);
  }

  init() async {
    _runners = await Future.wait(Iterable.generate(isolateCount, (_) => IsolateRunner.spawn()));
    _loadBalancer = LoadBalancer(_runners);

    _runners.forEach(
      (i) => i
          .run<void, AkaliIsolateArgs>(
            createIsolateFunction,
            AkaliIsolateArgs(port: serverPort),
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

  _runnerCrashCallback(IsolateRunner i, Error e) {
    int index = _runners.indexWhere((runner) => runner == i);
    _crashCount[index]++;
    if (_crashCount[index] < maxCrashCount) {
      i.run(
        createIsolateFunction,
        {"port": serverPort},
      );
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

Future<void> createAkaliIsolate(AkaliIsolateArgs args) async {
  var isolate = new AkaliIsolate(args);
  await isolate.init();
  print(".");
  return;
}

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

    _apiServer = ApiServer();
    _apiServer.addApi(AkaliApi(_db));

    _server = await HttpServer.bind(InternetAddress.anyIPv4, port, shared: true);
    listening = _server.listen(
      _handleRequest,
      onDone: _handleRequestDone,
      onError: _handleRequestError,
    );
    print('#$isolateName listening at localhost:$port');
  }

  void close() {
    listening.cancel();
  }

  _handleRequest(HttpRequest req) {
    print("#$isolateName: #${req.hashCode} ${req.requestedUri}");
    _apiServer.httpRequestHandler(req);
    // req.response
    //   ..write(".")
    //   ..close();
  }

  void _handleRequestDone() {
    print("#$isolateName: done");
  }

  void _handleRequestError(dynamic error, StackTrace stackTrace) {
    print("#$isolateName: ERROR!\n$error\n$stackTrace");
  }
}
