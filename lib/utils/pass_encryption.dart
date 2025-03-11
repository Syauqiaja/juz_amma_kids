import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordEncryption {
  // Encrypt the password
  String encryptPassword(String password) {
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  return hash.toString();
  }

  // Verify the password
  bool verifyPassword(String inputPassword, String storedHash) {
  final inputHash = encryptPassword(inputPassword);
  return inputHash == storedHash;
}
}
