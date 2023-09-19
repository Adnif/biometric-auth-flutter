import 'package:biometric_auth/providers/auth_provider.dart';
import 'package:biometric_auth/providers/device_info_provider.dart';
import 'package:biometric_auth/providers/models.dart';
import 'package:biometric_auth/screens/SecondScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LoginScreen extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceInfo = ref.watch(deviceInfoProvider);
    final String deviceId = deviceInfo.when(
      data: (data) {
        //device_id = data;
        return data;
      }, // Display device info here
      loading: () => 'Loading...', // Show loading text while waiting
      error: (error, stackTrace) => 'Error: $error',
    );

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(deviceId),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Masukan Email',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Masukan Password',
                ),
              ),
              ElevatedButton(
                child: Text('Login'),
                onPressed: () async {
                  final cred = await ref.read(loginProvider(LoginCredentials(
                          email: emailController.text,
                          password: passwordController.text,
                          device_id: deviceId))
                      .future);
                  if (cred == '200') {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SecondScreen()));
                  } else if (cred == '409') {
                    Fluttertoast.showToast(msg: 'Salah Email atau Password');
                  } else {
                    Fluttertoast.showToast(msg: 'Ada kesalahan dari server');
                  }
                  ;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
