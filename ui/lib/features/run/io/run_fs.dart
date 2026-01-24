import 'dart:convert';
import 'dart:io';

import '../domain/manifest.dart';

Future<Manifest> loadManifest(String runPath) async {
  final file = File('$runPath/manifest.json');
  final raw = await file.readAsString();
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return Manifest.fromJson(json);
}

String readTextFile(String runPath, String relativePath) {
  final file = File('$runPath/$relativePath');
  return file.readAsStringSync();
}

Map<String, dynamic> readJsonFile(String runPath, String relativePath) {
  final file = File('$runPath/$relativePath');
  final raw = file.readAsStringSync();
  return jsonDecode(raw) as Map<String, dynamic>;
}
