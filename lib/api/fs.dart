import 'dart:io';
import 'dart:async';

abstract class AkaliFileManager {
  FutureOr<FileManagementResponse> streamFileFrom(
      Stream<List<int>> file, String path);
}

class FileManagementResponse {
  bool success;
  String path;
  Map<String, dynamic> data;
}

class AkaliLocalFileManager implements AkaliFileManager {
  final String rootPath;

  AkaliLocalFileManager(this.rootPath);

  @override
  Future<FileManagementResponse> streamFileFrom(
    Stream<List<int>> file,
    String path,
  ) async {
    var f = File(rootPath + path);
    var writeSink = f.openWrite();
    await file.pipe(writeSink);
    await writeSink.close();
    return FileManagementResponse()
      ..success = true
      ..path = rootPath + path;
  }
}
