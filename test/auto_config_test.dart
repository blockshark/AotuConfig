import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auto_config/auto_config.dart';

void main() {
  const MethodChannel channel = MethodChannel('auto_config');

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
    expect(await AutoConfig.platformVersion, '42');
  });
}
