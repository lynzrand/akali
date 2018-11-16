import 'dart:io';
import 'dart:isolate';
import 'dart:async';
import 'dart:math';

import 'package:isolate/load_balancer.dart';
import 'package:isolate/isolate_runner.dart';
import 'package:isolate/ports.dart';

class AkaliLoadBalancer {
  HttpServer mainServer;
  int isolateCount;
  ReceivePort port;
  SendPort send;

  LoadBalancer _loadBalancer;
  List<IsolateRunner> _runners;

  AkaliLoadBalancer(this.isolateCount, {this.mainServer}) {
    port = ReceivePort();
  }

  init() async {
    _runners = await Future.wait(Iterable.generate(isolateCount, (_) => IsolateRunner.spawn()));
    _loadBalancer = LoadBalancer(_runners);
    _loadBalancer.runMultiple(
      isolateCount,
      createAkaliIsolate,
      <String, dynamic>{},
    );

    // (await Isolate.spawn<Map<String, dynamic>>(createAkaliIsolate, {"sendPort": port.sendPort}));
    // send = await port.first as SendPort;

    // mainServer.listen(_handle);
  }

  // _handle(HttpRequest req) async {
  //   print("Akali Load Balancer found request $req");
  //   _loadBalancer.run<void, HttpRequest>(testRunIsolate, req);
  // }
}

void createAkaliIsolate(dynamic data) async {
  var isolate = new AkaliIsolate(data as Map<String, dynamic>);
}

class AkaliIsolate {
  HttpServer _server;
  int isolateName;
  StreamSubscription listening;

  AkaliIsolate(Map<String, dynamic> data) {
    isolateName = data["isolateName"] ?? Random().nextInt(1024);
    _init();
  }

  void _init() async {
    _server = await HttpServer.bind(InternetAddress.anyIPv6, 8086, shared: true);
    listening = _server.listen(_handleRequest);
  }

  void close() {
    listening.cancel();
  }

  _handleRequest(HttpRequest req) {
    print("Akali isolate $isolateName recieved request ${req.hashCode} for ${req.requestedUri}");
    // TODO: put actrual BUSINESS LOGIC here!
    req.response
      ..write("HTTP 200 Okay\n")
      ..write(
          "This request is responded by Isolate $isolateName, and has a hashcode of ${req.hashCode}")
      ..close();
    print("Isolate $isolateName: ${req.hashCode} completed");
  }
}
