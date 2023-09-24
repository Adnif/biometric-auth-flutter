import 'dart:async';

import 'package:android_id/android_id.dart';
import 'package:biometric_auth/main.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  bool deviceState = true;
  late Timer timer;

  void checkDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    const _androidIdPlugin = AndroidId();
    final String? androidId = await _androidIdPlugin.getId();

    // final info = await DeviceInfoPlugin().androidInfo;
    final currId = androidId;

    if (currId != authcred.device_id) {
      await prefs.remove('token');
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
    // if (deviceState == false) {
    //   backToHome(context);
    // }
    return Scaffold(
      body: Center(child: Text("Sudah Bisa Masuk")),
    );
  }
}
