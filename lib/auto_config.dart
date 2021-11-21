
import 'dart:async';
import 'package:auto_config/android.dart' as android;
import 'package:auto_config/constants.dart' as constants;
import 'package:auto_config/ios.dart' as ios;
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:yaml/yaml.dart';

class AutoConfig {
  static const MethodChannel _channel = MethodChannel('auto_config');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
exec() {
  print('start');

  final config = loadConfigFile();

  final newName = config['name'];

  android.overwriteAndroidManifest(newName);
  ios.overwriteInfoPlist(newName);

  print('exit');
}

Map<String, dynamic> loadConfigFile() {
  final File file = File('pubspec.yaml');
  final String yamlString = file.readAsStringSync();
  final Map yamlMap = loadYaml(yamlString);

  if (yamlMap == null || !(yamlMap[constants.yamlKey] is Map)) {
    throw new Exception('flutter_launcher_name was not found');
  }

  // yamlMap has the type YamlMap, which has several unwanted sideeffects
  final Map<String, dynamic> config = <String, dynamic>{};
  for (MapEntry<dynamic, dynamic> entry in yamlMap[constants.yamlKey].entries) {
    config[entry.key] = entry.value;
  }

  return config;
}