import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceInfoProvider = FutureProvider<String>((ref) async {
  final _deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final info = await _deviceInfoPlugin.androidInfo;
    return info.id;
  }

  return "Bukan Android ya?";
});
