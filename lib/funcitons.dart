import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

String hash(String value) {
  var bytes = utf8.encode(value);
  var digest = sha256.convert(bytes);
  return digest.toString();
}

Future<File> compressImage(File file) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    file.absolute.path + "\\images\\compressed.jpg",
    quality: 70,
  );
  print("###########################");
  print(file.lengthSync());
  print(result.lengthSync());
  print("###########################");

  return result;
}
