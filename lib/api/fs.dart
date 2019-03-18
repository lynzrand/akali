import 'dart:io';
import 'dart:async';

import 'package:aqueduct/aqueduct.dart';

/// Base class for File Managers in Akali
abstract class AkaliFileManager {
  /// Takes a binary input stream and pipe into the designated file
  /// in the image folder
  FutureOr<FileManagementResponse> streamImageFileFrom(
      Stream<List<int>> file, String fileName);

  FutureOr<Stream<List<int>>> streamFileTo(String id, String ext);
}

class FileManagementResponse {
  bool success;
  String path;
  Map<String, dynamic> data;
}

class AkaliFileController extends FileController {
  AkaliFileController(String pathOfDirectoryToServe)
      : super(pathOfDirectoryToServe);
}

/// Defaule file manager. Stores files in a local directory.
class AkaliLocalFileManager implements AkaliFileManager {
  final String rootPath;
  final String webRootPath;
  static const String imgPath = 'img/';

  AkaliLocalFileManager(this.rootPath, this.webRootPath) {}

  @override
  Future<FileManagementResponse> streamImageFileFrom(
    Stream<List<int>> file,
    String fileName,
  ) async {
    var f = File(rootPath + imgPath + fileName);
    var writeSink = f.openWrite();
    await file.pipe(writeSink);
    await writeSink.close();
    return FileManagementResponse()
      ..success = true
      ..path = webRootPath + imgPath + fileName;
  }

  @override
  FutureOr<Stream<List<int>>> streamFileTo(String id, String ext) {
    var f = File(rootPath + imgPath + id + ext);
    return f.openRead();
  }
}

/// Simple file manager for testing purposes
class AkaliMockupFileManager implements AkaliFileManager {
  @override
  Future<FileManagementResponse> streamImageFileFrom(
    Stream<List<int>> file,
    String fileName,
  ) async {
    print(fileName);
    await for (var chunk in file) {
      print(chunk);
    }
    print('done!');
    return FileManagementResponse()
      ..success = true
      ..path = fileName;
  }

  @override
  FutureOr<Stream<List<int>>> streamFileTo(String id, String ext) {
    // TODO: implement streamFileTo
    return null;
  }
}
