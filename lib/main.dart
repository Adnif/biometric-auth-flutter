import 'dart:convert';
import 'dart:async';
import 'package:android_id/android_id.dart';
import 'package:biometric_auth/providers/auth_provider.dart';
import 'package:biometric_auth/screens/LoggedScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:biometric_auth/providers/models.dart';
import 'package:biometric_auth/screens/SecondScreen.dart';
import 'package:biometric_auth/screens/LoginScreen.dart';
import 'package:biometric_auth/screens/SignUpScreen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

LoginResults authcred = new LoginResults(
    token: null, statusCode: null, device_id: null, username: null);
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

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usn = prefs.getString('username');
    print("ini dalam fungsi getData : $usn");

    socket.emit('data', usn);
    socket.on('data', (data) {
      authcred.device_id = data;
    });

    const _androidIdPlugin = AndroidId();
    final String? androidId = await _androidIdPlugin.getId();

    final currId = androidId;
    if (currId != authcred.device_id) {
      authcred.token = null;
      await prefs.remove('token');
    }
    print('token sekarang: ${authcred.token}');
    print('device id sekarang: ${currId}');
    print('device id database sekarang: ${authcred.device_id}');
    print('username database sekarang: ${authcred.username}');
  }

  void checkToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null) {
      authcred.token = prefs.getString('token');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoggedScreen(),
          ));
    }
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

    Timer.periodic(Duration(seconds: 5), (timer) {
      _getData();
    });

    //_getData();
  }

  @override
  void dispose() {
    super.dispose();
    socket.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('ini didalam build ${authcred.device_id}');
    return MaterialApp(
      home: Builder(builder: (context) {
        checkToken(context);
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(authcred.device_id == null ? 'null' : authcred.device_id!),
                Text(
                  _canAuthenticate
                      ? "Can authenticate biometrics"
                      : "Cannot authenticate biometrics",
                  style: TextStyle(fontSize: 20),
                ),
                ElevatedButton(
                    onPressed: () async {
                      //Fluttertoast.showToast(msg: "nda bisa");
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
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
