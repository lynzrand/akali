import "package:path/path.dart" as path;
import "package:test/test.dart";
import "package:async/async.dart";
import "dart:io";
import "package:http/http.dart" as http;

import "package:akali/akali.dart";
import "package:aqueduct/aqueduct.dart";

/// Initialize Akali synchronously before being tested.
void boot() {
  final runConf = {
    "database": "127.0.0.1:27017",
    "storage-path": "./akali/",
    "web-root-path": "http://localhost:8086",
    "port": "8086",
    "isolates": 1
  };
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

  app.start(
    numberOfInstances: int.parse(runConf['isolates']),
  );
}

/// Testing APIs of Akali
void apiTest() {
  var uri = Uri.parse("127.0.0.1:27017");

  test("Query", () async {});

  test("Upload", () async {
    // file for test
    File postFile = new File("./test_post.png");
    var lengthOfPostFile = await postFile.length();
    var stream =
        new http.ByteStream(DelegatingStream.typed(postFile.openRead()));
    var requestPost = new http.MultipartRequest("POST", uri);
    requestPost.files.add(new http.MultipartFile(
        "file", stream, lengthOfPostFile,
        filename: path.basename(postFile.path)));
    var response = await requestPost.send();
    // TODO:: expected value
    expect(response, equals("abc"));
  });

  test("Get", () async {});
  test("Update", () async {});
}

/// Tesing auth model of Akali
void authTest() {
  // The descriptions below don't match the behaviour perfectly.
  test("Create users", () {});
  test("Remove users", () {});
  test("Priviledge control", () {});
  test("Connect with new clients", () {});
  test("Disconnect with clients", () {});
  test("Connection with clients lost", () {});
  test("Get ID of client alive", () {});
  test("Get token", () {});
  test("Add token", () {});
  test("Update token", () {});
  test("Add code", () {});
  test("Get code", () {});
  test("Remove code", () {});
  test("Get priviledge information", () {});
}

/// Test entry
void main() {
  boot();

  apiTest();
  authTest();
}
