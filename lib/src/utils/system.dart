import 'dart:io';

/// Creates file according to the [path]
///
/// Creates directories if they aren't exists.
/// [path] may be absolute or relative.
File createFile(String path) {
  final checkedPath = StringBuffer();
  final parts = path.split('/');
  final endDir = Directory(path.substring(0, path.lastIndexOf('/')));

  if (!endDir.existsSync()) {
    for (var i = 0; i < parts.length - 1; i++) {
      checkedPath.write(endDir.isAbsolute ? '/${parts[i]}' : '${parts[i]}/');
      if (!Directory(checkedPath.toString()).existsSync()) {
        Directory(checkedPath.toString()).createSync();
      }
    }
    checkedPath
        .write('${endDir.isAbsolute ? '/' : ''}${parts[parts.length - 1]}');
  }

  return File(checkedPath.toString());
}
