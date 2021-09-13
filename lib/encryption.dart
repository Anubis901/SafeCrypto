import 'dart:io';
import 'dart:convert';
import 'package:string_validator/string_validator.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;

String passwordPadded(String password, int lenght) {
  var bytes = utf8.encode(password); // data being hashed
  var digest = sha512.convert(bytes);

  return password + digest.toString().substring(1, lenght);
}

String encrypt(String password, dataString) {
  if (password.length != 32) {
    password = passwordPadded(password, 32 - password.length + 1);
  }

  final key = enc.Key.fromUtf8(password);
  final iv = enc.IV.fromLength(16);
  final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  final encrypted = encrypter.encrypt(dataString, iv: iv);

  return encrypted.base64;
}

String decrypt(String password, String dataString) {
  if (password.length != 32) {
    password = passwordPadded(password, 32 - password.length + 1);
  }

  final key = enc.Key.fromUtf8(password);
  final iv = enc.IV.fromLength(16);
  final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

  if (isBase64(dataString) == false) {
    return 'INVALID_VAULT';
  }

  var raw = enc.Encrypted.fromBase64(dataString);
  var decrypted = '';

  try {
    decrypted = encrypter.decrypt(raw, iv: iv);
  } catch (e) {
    return 'WRONG_PASSWORD';
  }

  return decrypted;
}

String readFile(String filePath) {
  String content = '';

  try {
    content = File(filePath).readAsStringSync();
  } catch (e) {
    // return e.toString();
    return '';
  }
  return content;
}

void writeData(String data, String filePath) {
  var encodedData = utf8.encode(data.toString());
  File(filePath).writeAsBytes(encodedData, mode: FileMode.write).then((file) => file.readAsBytes()).then((data) {});
}
