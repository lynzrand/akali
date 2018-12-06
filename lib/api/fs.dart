import 'dart:io';
import 'dart:async';

abstract class AkaliFileManager {
  Future<String> streamFileFrom(String path, Stream<List<int>> fileStream);
}

class AkaliLocalFileManager implements AkaliFileManager {
  final String rootPath;

  AkaliLocalFileManager(this.rootPath);

  @override
  Future<String> streamFileFrom(
      String path, Stream<List<int>> fileStream) async {
    var fileToWrite = File(rootPath + path);
    var writeSink = fileToWrite.openWrite();
    await fileStream.pipe(writeSink);
    return path;
  }
}
