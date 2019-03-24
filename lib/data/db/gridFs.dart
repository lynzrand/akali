import 'dart:async';
import 'dart:io';

import 'package:akali/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AkaliGridFS implements AkaliFileManager {
  static final String identifier = "GridFS";

  Db _db;
  GridFS _gridfs;

  AkaliGridFS(String link) {
    this._db = new Db(link);
    _db.open();
    this._gridfs = GridFS(_db);
  }

  @override
  Future<void> init() async {
    return;
  }

  @override
  FutureOr<bool> streamImageFileToClient(
      String id, String ext, IOSink target) async {
    var file = await _gridfs.findOne(id);
    if (file == null) throw FileSystemException("File not found");
    (file).writeTo(target);
    return true;
  }

  @override
  FutureOr<FileManagementResponse> streamImageFileFromUpload(
      Stream<List<int>> file, String fileName) async {
    var resultFile = _gridfs.createFile(file, fileName);
    await resultFile.save();
    var id = resultFile.id as ObjectId;
    return FileManagementResponse()
      ..success = true
      ..data = resultFile.data.map((k, v) =>
          (v is DateTime) ? MapEntry(k, v.toIso8601String()) : MapEntry(k, v))
      ..path = fileName;
  }
}
