import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginCredentials {
  String email;
  String password;
  String device_id;

  LoginCredentials(
      {required this.email, required this.password, required this.device_id});
}

class LoginResults {
  String? token;
  String? statusCode;
  String? device_id;
  String? username;

  LoginResults(
      {required this.token,
      required this.statusCode,
      required this.device_id,
      required this.username});
}

class SignUpCredentials extends LoginCredentials {
  String username;

  SignUpCredentials({
    required String email,
    required String password,
    required String device_id,
    required String this.username,
  }) : super(email: email, password: password, device_id: device_id);
}
