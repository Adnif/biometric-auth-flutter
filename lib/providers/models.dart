import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginCredentials {
  String email;
  String password;
  String device_id = 'XXX';

  LoginCredentials({required this.email, required this.password, device_id});
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
