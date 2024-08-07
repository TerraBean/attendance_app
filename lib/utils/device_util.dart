import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceUtils {
  static Future<String?> getDeviceId(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // Unique ID on iOS
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Unique ID on Android
    }
  }
}
