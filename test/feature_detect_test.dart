import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feature_detect/feature_detect.dart';

void main() {
  const MethodChannel channel = MethodChannel('feature_detect');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FeatureDetect.platformVersion, '42');
  });
}
