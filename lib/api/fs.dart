import 'dart:io';
import 'dart:async';

abstract class AkaliFileManager {
  FutureOr<FileManagementResponse> streamFileFrom(
      Stream<List<int>> file, String path);
}

class FileManagementResponse {
  bool success;
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
    writeSink.close();
    return FileManagementResponse()..success = true;
  }
}
