import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FeatureDetect {

  static const UI_MODE_TYPE_UNDEFINED = 0x0;
  static const UI_MODE_TYPE_NORMAL = 0x1;
  static const UI_MODE_TYPE_DESK = 0x2;
  static const UI_MODE_TYPE_CAR = 0x3;
  static const UI_MODE_TYPE_TELEVISION = 0x4;
  static const UI_MODE_TYPE_APPLIANCE = 0x5;
  static const UI_MODE_TYPE_WATCH = 0x6;
  static const UI_MODE_TYPE_VR_HEADSET = 0x7;

  static const MethodChannel _channel =
      const MethodChannel('com.rainway/feature_detect');

  /// Get a list of the names of all supported Android features on the device.
  static Future<List<String>> get systemAvailableFeatures async {
    if (!Platform.isAndroid) {
      throw UnsupportedError("This property is only available on Android.");
    }
    final List<dynamic> features = await _channel.invokeMethod('getSystemAvailableFeatures');
    
    return features.cast<String>();
  }

  /// Get the current Android UI mode type. Check it against the constants in this class.
  static Future<int> get currentUiModeType async {
    if (!Platform.isAndroid) {
      throw UnsupportedError("This property is only available on Android.");
    }
    final int uiMode = await _channel.invokeMethod('getCurrentUiModeType');
    return uiMode;
  }

  /// Check whether the device has support for a specific Android feature by its string name.
  static Future<bool> hasSystemFeature(String feature) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError("This method is only available on Android.");
    }
    final bool hasFeature = await _channel.invokeMethod('hasSystemFeature', {
      "feature": feature,
    });
    return hasFeature;
  }
}
