import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class Convert {
  

Future<File> writeToFile(ByteData data) async {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd–kk:mm').format(now);
  
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/$formattedDate.png'; 
    return File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
}