/*
  DO NOT USE THIS LIBRARY!

  This library involves some noob-trying-to-take-over-the-world stuff.
  Please ignore.
*/
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:mirrors';

class ApiHandler<InputType, ReturnType> {
  String path;

  Function<ReturnType>(InputType) handler;

  Function<InputType>(HttpRequest) argumentsGenerator;
  Function(ReturnType) serializer;

  List<int> _defaultSerializer(ReturnType i) {
    return JsonUtf8Encoder().convert(i);
  }

  handle(HttpRequest req) {
    serializer ??= this._defaultSerializer;
  }

  ApiHandler(this.argumentsGenerator, this.serializer);
}

class ApiGroup {
  Map<String, Function> apiHandlers;

  addHandler() {}

  getHandler() {}
}

class ApiServer {
  List<dynamic> apis = [];

  Map<String, int> apiLink;

  ApiServer(this.apis) {
    this.apis.forEach((api) {
      ClassMirror mirror = reflectClass(api);
      List<InstanceMirror> metas = mirror.metadata;
    });
  }

  handle(HttpRequest req) {}
}
