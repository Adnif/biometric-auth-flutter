import 'dart:convert';

import 'package:biometric_auth/screens/SecondScreen.dart';
import 'package:biometric_auth/screens/LoginScreen.dart';
import 'package:biometric_auth/screens/SignUpScreen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _canAuthenticate = false;
  late final LocalAuthentication auth;
  late IO.Socket socket = IO.io('http://10.0.2.2:3000',
      IO.OptionBuilder().setTransports(['websocket']).build());

  _connectSocket() {
    socket.onConnect((data) => print('Connection Established'));
    socket.onConnectError((data) => print('Connect Error $data'));
    socket.onDisconnect((data) => print('Socket.IO server disconnected'));
  }

  _getData() {
    socket.emit('data', (data) => {print(JsonDecoder(data))});
  }

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _canAuthenticate = isSupported;
        }));
    _getAvailableBiometrics();
    _connectSocket();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _canAuthenticate
                      ? "Can authenticate biometrics"
                      : "Cannot authenticate biometrics",
                  style: TextStyle(fontSize: 20),
                ),
                ElevatedButton(
                    onPressed: () async {
                      bool passed = await _authenticate();
                      if (passed == true) {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SecondScreen()));
                      } else {
                        Fluttertoast.showToast(msg: "nda bisa");
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      }
                    },
                    child: const Text('Login')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: const Text('Sign Up')),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<bool> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Coba auth Biometrik',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      print(authenticated);
      return authenticated;
      //print("Authenticated : $authenticated");
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    print("Biometrics yang tersedia : $availableBiometrics");

    if (!mounted) {
      return;
    }
  }

  Future<AndroidDeviceInfo> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    return androidInfo;
  }
}
