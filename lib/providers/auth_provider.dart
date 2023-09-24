import 'dart:convert';

import 'package:biometric_auth/main.dart';
import 'package:biometric_auth/providers/models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider =
    FutureProvider.family<LoginResults, LoginCredentials>((ref, log) async {
  final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': log.email,
        'password': log.password,
        'device_id': log.device_id
      }));

  //return response.statusCode.toString();

  if (response.statusCode == 200) {
    print(response.body);
    Map<String, dynamic> data = json.decode(response.body);
    //LoginResults authServe = new LoginResults(token: token, statusCode: statusCode, device_id: device_id, username: username)
    authcred.token = data['access-token'];
    authcred.username = data['username'];
    authcred.statusCode = response.statusCode.toString();
    return authcred;
  } else {
    print(response.statusCode);
    authcred.statusCode = response.statusCode.toString();
    return authcred;
  }
});

final deviceIdProvider = StreamProvider((ref) async* {});
