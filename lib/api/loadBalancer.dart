import 'dart:io';
import 'dart:isolate';
import 'dart:async';
import 'dart:math';

import 'package:isolate/load_balancer.dart';
import 'package:isolate/isolate_runner.dart';
import 'package:isolate/ports.dart';

import 'package:rpc/rpc.dart';

import 'package:akali/api/api.dart';

class AkaliLoadBalancer {
  HttpServer mainServer;
  int serverPort;
  int isolateCount;
  ReceivePort port;
  SendPort send;

  LoadBalancer _loadBalancer;
  List<IsolateRunner> _runners;

  AkaliLoadBalancer(this.isolateCount, {this.mainServer, this.serverPort}) {
    port = ReceivePort();
  }

  init() async {
    _runners = await Future.wait(Iterable.generate(isolateCount, (_) => IsolateRunner.spawn()));
    _loadBalancer = LoadBalancer(_runners);

    _runners.forEach(
      (i) => i.run<void, Map<String, dynamic>>(createAkaliIsolate, {"port": serverPort}),
    );

    // _loadBalancer.runMultiple(
    //   isolateCount,
    //   createAkaliIsolate,
    //   <String, dynamic>{},
    // );
  }
}

Future<void> createAkaliIsolate(dynamic data) async {
  var isolate = new AkaliIsolate(data as Map<String, dynamic>);
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

  AkaliIsolate(Map<String, dynamic> data) {
    isolateName = data["isolateName"] ?? Random().nextInt(99);
    port = data['port'] ?? 8086;
  }

  void init() async {
    _apiServer = ApiServer();
    _apiServer.addApi(AkaliApi());

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
