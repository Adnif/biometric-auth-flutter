import 'dart:async';

import 'package:android_id/android_id.dart';
import 'package:biometric_auth/main.dart';
import 'package:biometric_auth/screens/SecondScreen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggedScreen extends StatefulWidget {
  @override
  _LoggedScreenState createState() => _LoggedScreenState();
}

class _LoggedScreenState extends State<LoggedScreen> {
  late final LocalAuthentication auth;
  bool deviceState = true;
  late Timer timer;

  void checkDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const _androidIdPlugin = AndroidId();
    final String? androidId = await _androidIdPlugin.getId();

    final currId = androidId;

    if (currId != authcred.device_id) {
      Fluttertoast.showToast(msg: 'Akun telah login di device lain');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ));
    }
  }

  void backToHome(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyApp(),
        ));
  }

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    //checkDevice();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkDevice();
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  bool passed = await _authenticate();
                  if (passed == true) {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SecondScreen()));
                  } else {
                    Fluttertoast.showToast(msg: "Anda tidak dikenali");
                  }
                },
                child: const Text('Verify'))
          ],
        ),
      ),
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
}
