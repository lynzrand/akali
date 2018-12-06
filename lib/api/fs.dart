import 'dart:io';
import 'dart:async';

abstract class AkaliFileManager {
  FutureOr<FileManagementResponse> streamImageFileFrom(
      Stream<List<int>> file, String fileName);
}

class FileManagementResponse {
  bool success;
  String path;
  Map<String, dynamic> data;
}

class AkaliLocalFileManager implements AkaliFileManager {
  final String rootPath;
  final String webRootPath;
  static const String imgPath = 'img/';

  AkaliLocalFileManager(this.rootPath, this.webRootPath);

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
}

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
}
