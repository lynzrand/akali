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
    this._gridfs = GridFS(_db);
  }

  @override
  Future<void> init() {}

  @override
  FutureOr<bool> streamFileTo(String id, String ext, IOSink target) async {
    var file = await _gridfs.findOne(id);
    if (file == null) throw FileSystemException("File not found");
    (file).writeTo(target);
    return true;
  }

  @override
  FutureOr<FileManagementResponse> streamImageFileFrom(
      Stream<List<int>> file, String fileName) {
    var resultFile = _gridfs.createFile(file, fileName);
    var id = resultFile.id as ObjectId;
    return FileManagementResponse()
      ..success = true
      ..data = resultFile.data
      ..path = id.toHexString();
  }
}
