import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceInfoProvider = FutureProvider<String?>((ref) async {
  final _deviceInfoPlugin = DeviceInfoPlugin();

  const _androidIdPlugin = AndroidId();
  final String? androidId = await _androidIdPlugin.getId();

  // final info = await DeviceInfoPlugin().androidInfo;
  final String? currId = androidId;

  if (Platform.isAndroid) {
    final info = await _deviceInfoPlugin.androidInfo;
    return currId;
  }

  return "Bukan Android ya?";
});
