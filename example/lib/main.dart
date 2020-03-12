import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:feature_detect/feature_detect.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _features = 'Checking features...';
  String _hasTouchscreen = "Checking for touchscreen...";
  String _uiMode = "Checking UI mode...";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String features;
    bool hasTouchscreen = false;
    String tvMessage = "Unknown";
    String uiMode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      features = (await FeatureDetect.systemAvailableFeatures).toString();
    } on PlatformException {
      features = 'Failed to get system features.';
    } on UnsupportedError {
      features = 'Not running on Android!';
    }

    try {
      hasTouchscreen = await FeatureDetect.hasSystemFeature(
        "android.hardware.touchscreen",
      );
      if (hasTouchscreen) {
        tvMessage = "Device has a touchscreen.";
      }
      else {
        tvMessage = "Device does not have a touchscreen.";
      }
    } on PlatformException {
      tvMessage = "Failed to check for touchscreen.";
    } on UnsupportedError {
      tvMessage = "Not running on Android!";
    }

    try {
      uiMode = (await FeatureDetect.currentUiModeType).toString();
    } on PlatformException {
      uiMode = "Failed to check UI mode.";
    } on UnsupportedError {
      uiMode = "Not running on Android!";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _features = features;
      _hasTouchscreen = tvMessage;
      _uiMode = uiMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('feature_detect example app'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              Text('Touchscreen: $_hasTouchscreen'),
              Text('UI mode: $_uiMode'),
              Text('Features available: $_features\n'),
            ],
          ),
        ),
      ),
    );
  }
}
