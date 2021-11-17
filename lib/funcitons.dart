import 'dart:convert';
import 'package:crypto/crypto.dart';

String hash(String value) {
  var bytes = utf8.encode(value);
  var digest = sha256.convert(bytes);
  return digest.toString();
}
